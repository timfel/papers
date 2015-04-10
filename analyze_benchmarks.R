#! /usr/bin/env Rscript

# in inches
figure.width <- 7
figure.height <- 2
# figure.width <- 8.5
# figure.height <- 3


# .geomean.text <- 'geometric\nmean'
.geomean.text <- 'geometric mean'

reference.vm <- 'Interpreter'
target.vm <- 'RSqueak'


CAPPING <- 20

pkgs = c(
  "reshape2",
  "plyr",
  #"beanplot",
  "boot",
  "Hmisc",
  "ggplot2",
  "tools",
  "xlsx",
  "dplyr"
)

use <- function(pkg) {
  if (!require(pkg, character.only=TRUE)) { install.packages(pkg, repos="http://cran.rstudio.com") }
  library(pkg,character.only=TRUE)
}
sapply(pkgs, use)
if (!require(extrafont)) {
  install.packages("devtools", repos="http://cran.rstudio.com")
  library(devtools)
  install_github("wch/Rttf2pt1", ref='21c5dbc42bedf1714cc11c8a3c0d5086d4e7b85f')
  install_github("wch/extrafont")
}
library(extrafont)
loadfonts(quiet=TRUE)
if (length(fonts()) == 0) {
  font_import(prompt=FALSE)
}

pdf.embed.options <- "-dEmbedAllFonts=true -dPDFSETTINGS=/prepress -dCompatibilityLevel=1.4 -dSubsetFonts=true -dHaveTrueTypeFonts=true"

# ---- cmd line ----

if (FALSE) {
  setwd("~/Documents/Uni/Paper/icooolps2015-algo-prims")
}

if (length(commandArgs(trailingOnly=TRUE)) > 0) {
  tsv_name = commandArgs(trailingOnly=TRUE)[1]
} else {
  tsv_name <- "benchmarks.txt"
}

if (!file.exists(tsv_name)) {
  stop("Cannot open input file ", tsv_name)
}

input.basename = file_path_sans_ext(tsv_name)

bench <- read.table(tsv_name, comment.char = "#", header=FALSE,
                    sep = ";",
                    col.names=c('benchmark', 'vm', 'value'))
bench$vm <- sapply(bench$vm, function (x)
  if (x=='Stack') 'Interpreter' else paste0("",x))

bench$vm <- factor(bench$vm, levels = c(target.vm, "Cog", "Interpreter"))




# ------ functions -----
`%ni%` = Negate(`%in%`) 


confInterval095Error <- function (samples) {
  if (length(sample) < 30)
    qnorm(0.975) * sd(samples) / sqrt(length(samples))
  else
    qt(0.975, df=length(samples)-1) * sd(samples) / sqrt(length(samples))
}

div_mean_x_y = function(data, indices, extraid) {
    indexx = indices[extraid == "x"]
    indexy = indices[extraid == "y"]
    mean(data[indexx]) / mean(data[indexy])
}

normalize_value_bootstrap_confidence = function(x, y, R=1000) {
    # x and y need to be *vectors* of all the values
    # the result is the confidence interval of mean(x) / mean(y)
    total <- c(x,y)
    id <- as.factor(c(rep("x",length(x)),rep("y",length(y))))

    b <- boot(total, div_mean_x_y, strata=id, R=R, extraid=id)
    norm <- boot.ci(b, type=c("norm"))$normal
    dimnames(norm) <- list(NULL,c("conf", "upper", "lower"))
    norm
}

bootstrapTo <- function(df, supergroup, group, val, var) {
  cmp <- df[(df[[group]] == val),]
  doIt <- function(X) {
    .X <- X[(!is.na(X[[var]])),]
    if (1 > nrow(.X)) {
      return(as.matrix(data.frame(conf=NA, upper=NA, lower=NA)))
    }
    ident <- (X[[supergroup]])[[1]]
    subs <- cmp[(cmp[[supergroup]] == ident),]
    comparee <- subs[[var]]
#     print(X[[group]][[1]])
#     print(ident)
#     print(is.na(comparee))
    if (length(comparee[!is.na(comparee)]) != length(comparee)) {
      return(as.matrix(data.frame(conf=NA, upper=NA, lower=NA)))
    }
    normalize_value_bootstrap_confidence(.X[[var]], comparee)
  }
  ddply(df, c(supergroup,group), doIt)  
}

normalizeTo <- function(df, supergroup, group, val, var, vars=c(var)) {
  data <- df
  sg <- droplevels(df[[supergroup]])
  indexes <- which(df[[group]] == val)
  norm.factor <- (df[[var]])[indexes]
  names(norm.factor) <- droplevels(sg[indexes])
  for (normvar in vars) {
    divis <- norm.factor[ sg ]
    res <- df[[normvar]]/divis
    data[[paste0(normvar,".norm")]] <- res
  }
  data
}

geomean <- function(X) {
  value <- na.omit(X[X > 0])
  exp(mean(log(value)))
}


# --- shaping data


multi.variate <- FALSE

num.vms <- length(levels(factor(bench$vm)))
num.runs <- length(bench$benchmark)
num.benches <- length(levels(bench$benchmark))

rigorous <- num.runs > (num.vms * num.benches)

bench.corr = data.frame()
for (vm in levels(bench$vm)) {  
  for (benchmark in levels(bench$benchmark)) {
    if (1 > nrow(bench[(
        bench$vm == vm &
        bench$benchmark == benchmark
      ),,])) {
      .x <- data.frame(vm=vm,benchmark=benchmark,value=NA)
      bench.corr <- rbind(bench.corr, .x)
      if (rigorous) {
        bench.corr <- rbind(bench.corr, .x)
        bench.corr <- rbind(bench.corr, .x)
        bench.corr <- rbind(bench.corr, .x)
        bench.corr <- rbind(bench.corr, .x)
        bench.corr <- rbind(bench.corr, .x)
        bench.corr <- rbind(bench.corr, .x)
        bench.corr <- rbind(bench.corr, .x)            
        bench.corr <- rbind(bench.corr, .x)
        bench.corr <- rbind(bench.corr, .x)            
        
      }
    }
  }
}
bench <- rbind(bench, bench.corr)


######################################################

group.by <- as.quoted(c("benchmark","vm"))

bench.tot <- bench
bench.summary <- ddply(bench.tot, group.by, plyr::summarize, 
                       overall=FALSE,
                       mean=mean(value),
                       median=median(value),
                       stdev=sd(value),
                       err095=confInterval095Error(value),
                       cnfIntHigh = mean(value) + (confInterval095Error(value)),
                       cnfIntLow = mean(value) - (confInterval095Error(value))
)
bench.err <- bootstrapTo(bench.tot, 'benchmark', 'vm', reference.vm, 'value')
bench.summary <- merge(
  normalizeTo(bench.summary, 'benchmark', 'vm', reference.vm, 'mean'),
  bench.err
)



.selection <- c('vm','mean.norm')
.ids <- c('vm')
.group.by <- as.quoted(c("vm"))

bench.summary.overall <- ddply(melt(bench.summary[.selection], id.vars=.ids), .group.by,
                               plyr::summarize, 
                               overall=TRUE,
                               benchmark=.geomean.text,
                               mean=1,
                               mean.norm=geomean(value),
                               median=1
)
print(">>>> OVERALL\n")
print(bench.summary.overall)

bench.summary.overall <- merge(bench.summary.overall, data.frame(stdev=1, err095=1, cnfIntHigh=1,
                                                                 cnfIntLow=1, conf=1, upper=NA, lower=NA))
# bench.summary.graph <- data.frame(bench.summary)
# bench.summary.graph <- rbind(bench.summary.graph, bench.summary.overall) 
bench.summary.graph <- rbind(bench.summary, bench.summary.overall) 

bench.summary.graph$isCapped <- " "
.needs.cap <- bench.summary.graph[!is.na(bench.summary.graph$mean.norm) & bench.summary.graph$mean.norm > CAPPING,]
if (nrow(.needs.cap) > 0) {
  bench.summary.graph[!is.na(bench.summary.graph$mean.norm) & bench.summary.graph$mean.norm > CAPPING,]$isCapped <-
    paste0("> ", format(.needs.cap$mean.norm,digits=0))
  bench.summary.graph[!is.na(bench.summary.graph$mean.norm) & bench.summary.graph$mean.norm > CAPPING,]$mean.norm <- CAPPING
}



sel.col <- c('benchmark','vm','mean','err095')
bench.summary.sel <- dcast(melt(bench.summary[sel.col], id.vars=c('benchmark','vm')), benchmark ~ vm + variable)
bench.summary.ltx <- bench.summary.sel[2:length(bench.summary.sel)]
rownames(bench.summary.ltx) <- bench.summary.sel$benchmark
colnames(bench.summary.ltx) <- sapply(colnames(bench.summary.ltx), function(x) {sedit(x, '_', ' ')})

# ----- Outputting -----


# order benches by target vm
mn <- mapply(function(vm, n) {if (vm == target.vm)  n else Inf }, bench.summary.graph$vm, bench.summary.graph$mean.norm)

bench.summary.graph$benchmark <- 
  reorder(bench.summary.graph$benchmark, mn, min)


# Excel for overall data
write.xlsx(bench.tot, paste0(input.basename, ".xlsx"), append=FALSE, sheetName="bench")
write.xlsx(bench.summary, paste0(input.basename, ".xlsx"), append=TRUE, sheetName="summary")


# Normalized bargraph
dodge <- position_dodge(width=.75)
ymax <- round_any(max(bench.summary.graph$mean.norm, na.rm=TRUE), 0.5, ceiling)
p <- ggplot(data=bench.summary.graph,
       aes(x=benchmark,y=mean.norm,group=interaction(benchmark,vm),fill=vm)
) +
  geom_bar(stat="identity", position=dodge, width=.6, aes(fill = vm))+
  geom_point(position=dodge,aes(y=0.5, ymax=ymax, shape=vm),size=2, color="grey90",stat="identity") +
  ylab("Relative Runtime") +
  theme_bw(base_size=6, base_family="Helvetica") +
  theme(
    rect = element_rect(),
    axis.title.x =  element_blank(),
    #     axis.title.x = element_text(face="bold", size=9),
    axis.text.x  = element_text(size=6), #angle=45, vjust=0.2,
    #     axis.text.x  = element_text(size=6, angle=45, hjust=1),
    axis.title.y = element_text(face="bold", size=6),
    axis.text.y  = element_text(size=6), #angle=45, hjust=0.2, vjust=0.5,
    legend.position=c(0.35, .8),
    plot.margin = unit(c(-3,3,-1,-1),"mm"), #top, right, bottom, left 
    legend.text = element_text(size=6),
    legend.title = element_text(size=6, face="bold"),
    legend.background = element_rect(fill="gray90", size=0),
    legend.margin = unit(0, "cm"),
    legend.key=element_rect(fill="white"),
    legend.key.size=unit(3,"mm")
  )
if (.needs.cap) {
  p <- p + geom_text(position=dodge,aes(y=(CAPPING * .95), ymax=ymax,label=isCapped), size=3) 
}
p <- p +
  scale_y_continuous(breaks=seq(0,ymax,1), limits=c(0,ymax),expand=c(0,0)) +
  scale_fill_brewer(name = "Virtual Machine", type="qual", palette="Set1") + 
  scale_shape(name = "Virtual Machine", solid = FALSE)
if (rigorous) {
  p <- p + geom_errorbar(aes(ymin=lower, ymax = upper),  position=dodge, color=I("black"), size=.2)  
}
p <- p + facet_grid(. ~ overall, scales="free", space="free",labeller=label_bquote(""))
p


gg.file <- paste0(input.basename, ".pdf")
ggsave(gg.file, width=figure.width, height=figure.height, units=c("in"), colormodel='rgb')
#ggsave(gg.file, width=20, height=7, units=c("in"), colormodel='rgb')
embed_fonts(gg.file, options=pdf.embed.options)


# LaTeX table, all
(function() {
  if (nrow(bench.summary.ltx) <= 0) {
    return();
  }
  len <- ncol(bench.summary.ltx)/2
  .just = rep(c('r','@{}>{\\smaller\\ensuremath{\\pm}}r@{\\,\\si{\\milli\\second}}'), len)
  .just = c('@{}r', .just[2:length(.just)])
  ## .long <- nrow(bench.summary.ltx) > 50
  out <- if (nrow(bench.summary.ltx) > 50) {
         latex(bench.summary.ltx,
               star=TRUE,
               file=paste0(input.basename, "-all.tex"),
               rowlabel="Benchmark",
               booktabs=TRUE,
               table.env=FALSE,
               center="none",
               longtable=TRUE,
               lines.page=999999,
               size="small", #center="centering",
               colheads=rep(c('mean', ''), len),
               col.just=.just,
               #col.just=rep(c('r','@{\\,\\si{\\milli\\second} \\ensuremath{\\pm}}r'), len),
               cgroup=levels(as.factor(bench.summary$vm)),
               cdec=rep(0, len*2))
     } else {
         latex(bench.summary.ltx,
               file=paste0(input.basename, "-all.tex"),
               rowlabel="Benchmark",
               booktabs=TRUE,
               center="none",
               size="small", #center="centering",
               colheads=rep(c('mean', ''), len),
               col.just=.just,
               table.env=FALSE,
               #col.just=rep(c('r','@{\\,\\si{\\milli\\second} \\ensuremath{\\pm}}r'), len),
               cgroup=levels(as.factor(bench.summary$vm)),
               cdec=rep(0, len*2))
     }
})()


bench.info <- bench.summary

target.timings <- (bench.info[bench.info$vm == target.vm,,])$mean.norm

print(paste0(">> slowest ", target.vm))
print(max(target.timings))
print(paste0(">> fastes ", target.vm))
print(1/min(target.timings))

winners <- bench.info %>% group_by(benchmark) %>% filter(mean.norm == min(mean.norm))
winners <- winners[c('mean.norm','benchmark','vm')]
winners <- winners[do.call(order, winners),]
print(paste0(target.vm, " wins in "));
print(winners[winners$vm == target.vm,,])
print("(this is")
print(nrow(winners[winners$vm == target.vm,,]))
print("out of")
print(nrow(winners))



print(">> done");

