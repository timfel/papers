#! /usr/bin/env Rscript

pkgs = c(
  "reshape2",
  "plyr",
  #"beanplot",
  "boot",
  "Hmisc",
  "ggplot2",
  "tools",
  "quantreg",
  "locfit",
  "xlsx"
)

use <- function(pkg) {
  if (!require(pkg, character.only=TRUE)) { install.packages(pkg) }
  library(pkg,character.only=TRUE)
}
sapply(pkgs, use)
if (!require(extrafont)) {
  install.packages("devtools")
  library(devtools)
  install_github("Rttf2pt1", "wch")
  install_github("extrafont", "wch")
}
library(extrafont)
loadfonts(quiet=TRUE)
if (length(fonts()) == 0) {
  font_import(prompt=FALSE)
}


# ---- cmd line ----

if (FALSE) {
  setwd("/Users/tobias/Documents/Uni/Paper/squeakjs-paper")
}


# in inches
figure.width <- 7
figure.height <- 2.5

no.graph.vms <- c('Squeak', 'Potato')

Platform.ids <- "benchmark-ids.tsv"
timings <- "benchmarks-timings.tsv"
timings.osx <- "benchmarks-timings-osx.tsv"
speed <- "benchmarks-tiny.tsv"
speed.osx <- "benchmarks-tiny-osx.tsv"

input.basename <- "benchmarks"

bench.ids <- read.delim(Platform.ids, comment.char = "#", header=TRUE)
bench.timings <- read.delim(timings, comment.char = "#", header=TRUE)
bench.timings.osx <- read.delim(timings.osx, comment.char = "#", header=TRUE)
bench.speed <- read.delim(speed, comment.char = "#", header=TRUE)
bench.speed.osx <- read.delim(speed.osx, comment.char = "#", header=TRUE)


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
  
  if(length(unique(total)) > 1) {
    b <- boot(total, div_mean_x_y, strata=id, R=R, extraid=id)
    norm <- boot.ci(b, type=c("norm"))$normal
    dimnames(norm) <- list(NULL,c("conf", "lower", "upper"))
    norm
  } else {
    matrix(c(0.95,mean(total),mean(total)),
           nrow=1,ncol=3,
           dimnames=list(NULL,c("conf", "lower", "upper")))
  }
}

bootstrapTo <- function(df, supergroup, group, val, var) {
  cmp <- df[(df[[group]] == val),]
  doIt <- function(X) {
    ident <- (X[[supergroup]])[[1]]
    subs <- cmp[(cmp[[supergroup]] == ident),]
    comparee <- subs[[var]]
    normalize_value_bootstrap_confidence(X[[var]], comparee)
  }
  ddply(df, c(supergroup,group), doIt)  
}

normalizeTo <- function(df, supergroup, group, val, var, vars=c(var)) {
  data <- df
  sg <- droplevels(df[[supergroup]])
  indexes <- which(df[[group]] == val)
  norm.factor <- (df[[var]])[indexes]
  names(norm.factor) <- sg[indexes]
  for (normvar in vars) {
    divis <- norm.factor[ sg ]
    res <- df[[normvar]]/divis
    data[[paste0(normvar,".norm")]] <- res
  }
  data
}

# --- shaping data

bench.speed.m <- melt(bench.speed, id.vars='VM')
bench.speed.osx.m <- melt(bench.speed.osx, id.vars='VM')

bench.timings$value <- bench.timings$total
bench.timings.osx$value <- bench.timings.osx$total

bench.timings.err <- bootstrapTo(bench.timings, 'Benchmark', 'VM', 'Squeak', 'value')
bench.timings.err.osx <- bootstrapTo(bench.timings.osx, 'Benchmark', 'VM', 'SqueakOSX', 'value')

bench.speed.err <- bootstrapTo(bench.speed.m, 'variable', 'VM', 'Squeak', 'value')
bench.speed.err.osx <- bootstrapTo(bench.speed.osx.m, 'variable', 'VM', 'SqueakOSX', 'value')


#--------------------------------- speed -----------------------------------------------------------------------

bench.speed.summary.raw <- ddply(bench.speed.m, .(variable,VM), summarise,
                               mean=mean(value),
                               median=median(value),
                               stdev=sd(value),
                               err095=confInterval095Error(value),
                               cnfIntHigh = mean(value) + (confInterval095Error(value)),
                               cnfIntLow = mean(value) - (confInterval095Error(value))
)
bench.speed.osx.summary.raw <- ddply(bench.speed.osx.m, .(variable,VM), summarise,
                               mean=mean(value),
                               median=median(value),
                               stdev=sd(value),
                               err095=confInterval095Error(value),
                               cnfIntHigh = mean(value) + (confInterval095Error(value)),
                               cnfIntLow = mean(value) - (confInterval095Error(value))
)
bench.speed.osx.summary.norm <- normalizeTo(bench.speed.osx.summary.raw, 'variable', 'VM', 'SqueakOSX', 'mean')

bench.speed.summary <- merge(
  normalizeTo(bench.speed.summary.raw, 'variable', 'VM', 'Squeak', 'mean'),
  bench.speed.err
)
bench.speed.osx.summary <- merge(
  bench.speed.osx.summary.norm, # [bench.speed.osx.summary.norm$VM != 'SqueakOSX',,drop=TRUE],
  bench.speed.err.osx, #[bench.speed.err.osx$VM != 'SqueakOSX',,drop=TRUE]
)

bench.summary.speed.graph <- rbind(bench.speed.summary, bench.speed.osx.summary[bench.speed.osx.summary$VM != 'SqueakOSX',,drop=TRUE])
bench.summary.speed.raw <- merge(
  rbind(bench.speed.summary.raw, bench.speed.osx.summary.raw),
  bench.ids)

data.speed <- merge(bench.summary.speed.graph[bench.summary.speed.graph$VM %ni% no.graph.vms,,drop=TRUE], bench.ids);
# Normalized bargraph 3
dodge <- position_dodge(width=.8)
interval <- 50
ymax <- round_any(max(1/data.speed$lower), interval, ceiling)
#ymax <- round_any(max(data.speed$upper), interval, ceiling)
ggplot(data=data.speed,
       aes(x=variable,y=1/mean.norm,group=interaction(variable,VM),fill=VM)
) +
  geom_bar(stat="identity", position=dodge, width=.75, aes(fill = VM),  )+
  geom_errorbar(aes(ymin=1/lower, ymax = 1/upper),  position=dodge, color=I("black"), size=.33) +
  #   xlab("Benchmark") +
  ylab("Relative Slowdown") +
  theme_bw(base_size=8, base_family="Helvetica") +
  theme(
    rect = element_rect(),
    axis.title.x =  element_blank(),
    #     axis.title.x = element_text(face="bold", size=9),
    #     axis.text.x  = element_text(size=9), #angle=45, vjust=0.2,
    #axis.text.x  = element_text(size=8, angle=45, hjust=1),
    axis.text.x  = element_text(size=8),
    axis.title.y = element_text(face="bold", size=8),
    axis.text.y  = element_text(size=8), #angle=45, hjust=0.2, vjust=0.5,
    legend.position=c(0.75, 0.78),
    #plot.margin = unit(c(-3.2,3,-4,-1),"mm"),
    plot.margin = unit(c(1,3,-1.6,-.5),"mm"),
    legend.text = element_text(size=7),
    legend.title = element_text(size=7, face="bold"),
    legend.background = element_rect(fill="gray90", size=0),
    legend.margin = unit(0, "cm"),
    legend.key=element_rect(fill="white"),
    legend.key.size=unit(5,"mm")
  ) +
  scale_x_discrete(labels=c('Bytecodes per second','Sends per second')) +
  scale_y_continuous(breaks=seq(0,ymax,interval), limits=c(0,ymax),expand=c(0,0)) +
  scale_fill_brewer(name = "Platform", type="qual", palette="Set1",labels=levels(droplevels(data.speed$VMshort))) +
  facet_null()
gg.file <- paste0(input.basename, "-speed.pdf")
ggsave(gg.file, width=figure.width/2, height=figure.height * .95 , units=c("in"), colormodel='rgb')
embed_fonts(gg.file, options="-dPDFSETTINGS=/prepress")

# ----------------------------------------------- timings

bench.timings.summary.raw <- ddply(bench.timings, .(Benchmark,VM), summarise,
                               mean=mean(value),
                               median=median(value),
                               stdev=sd(value),
                               err095=confInterval095Error(value),
                               cnfIntHigh = mean(value) + (confInterval095Error(value)),
                               cnfIntLow = mean(value) - (confInterval095Error(value))
)
bench.timings.osx.summary.raw <- ddply(bench.timings.osx, .(Benchmark,VM), summarise,
                                   mean=mean(value),
                                   median=median(value),
                                   stdev=sd(value),
                                   err095=confInterval095Error(value),
                                   cnfIntHigh = mean(value) + (confInterval095Error(value)),
                                   cnfIntLow = mean(value) - (confInterval095Error(value))
)
bench.timings.osx.summary.norm <- normalizeTo(bench.timings.osx.summary.raw, 'Benchmark', 'VM', 'SqueakOSX', 'mean')

bench.timings.summary <- merge(
  normalizeTo(bench.timings.summary.raw, 'Benchmark', 'VM', 'Squeak', 'mean'),
  bench.timings.err
)
bench.timings.osx.summary <- merge(
  bench.timings.osx.summary.norm, #[bench.timings.osx.summary.norm$VM != 'SqueakOSX',,drop=TRUE],
  bench.timings.err.osx, #[bench.timings.err.osx$VM != 'SqueakOSX',,drop=TRUE]
)

bench.summary.graph <- rbind(bench.timings.summary, bench.timings.osx.summary[bench.timings.osx.summary$VM != 'SqueakOSX',,drop=TRUE])
bench.summary.raw <- merge(
  rbind(bench.timings.summary.raw, bench.timings.osx.summary.raw),
  bench.ids)

data.bench <- merge(bench.summary.graph[bench.summary.graph$VM %ni% no.graph.vms,,drop=TRUE], bench.ids)
# Normalized bargraph 3
dodge <- position_dodge(width=.8)
interval <- 50
#ymax <- round_any(max(1/data.bench$lower), interval, ceiling)
ymax <- round_any(max(data.bench$upper), interval, ceiling)
ggplot(data=data.bench,
       aes(x=Benchmark,y=mean.norm,group=interaction(Benchmark,VM),fill=VM,)
) +
  geom_bar(stat="identity", position=dodge, width=.75, aes(fill = VM),  )+
  geom_errorbar(aes(ymin=lower, ymax = upper),  position=dodge, color=I("black"), size=.33) +
  #   xlab("Benchmark") +
  ylab("Relative Execution Time") +
  theme_bw(base_size=8, base_family="Helvetica") +
  theme(
    rect = element_rect(),
    axis.title.x =  element_blank(),
    #     axis.title.x = element_text(face="bold", size=9),
    #     axis.text.x  = element_text(size=9), #angle=45, vjust=0.2,
    #axis.text.x  = element_text(size=8, angle=45, hjust=1),
    axis.text.x  = element_text(size=8),
    axis.title.y = element_text(face="bold", size=8),
    axis.text.y  = element_text(size=8), #angle=45, hjust=0.2, vjust=0.5,
    legend.position=c(0.75, .75),
    #plot.margin = unit(c(-3.2,3,-4,-1),"mm"),
    plot.margin = unit(c(1,3,-1.6,-.5),"mm"),
    legend.text = element_text(size=7),
    legend.title = element_text(size=7, face="bold"),
    legend.background = element_rect(fill="gray90", size=0),
    legend.margin = unit(0, "cm"),
    legend.key=element_rect(fill="white"),
    legend.key.size=unit(5,"mm")
  ) +
  scale_y_continuous(breaks=seq(0,ymax,interval), limits=c(0,ymax),expand=c(0,0)) +
  #scale_fill_grey(name = "Virtual Machine") +
  scale_fill_brewer(name = "Platform", type="qual", palette="Set1", labels=levels(droplevels(data.bench$VMshort))) +
  facet_null()
gg.file <- paste0(input.basename, "-timings.pdf")
ggsave(gg.file, width=figure.width, height=figure.height * 1.15 , units=c("in"), colormodel='rgb')
embed_fonts(gg.file, options="-dPDFSETTINGS=/prepress")

bench.summary.sel <- dcast(melt(bench.summary.raw[c('Benchmark','VM','mean','err095')], id.vars=c('Benchmark','VM')), Benchmark ~ VM + variable)
bench.summary.ltx <- bench.summary.sel[2:length(bench.summary.sel)]
rownames(bench.summary.ltx) <- bench.summary.sel$Benchmark
colnames(bench.summary.ltx) <- sapply(colnames(bench.summary.ltx), function(x) {sedit(x, '_', ' ')})

bench.summary.speed.sel <- dcast(melt(bench.summary.speed.raw[c('variable','VM','mean','err095')], id.vars=c('variable','VM'), variable.name='result'), variable ~ VM + result)
bench.summary.speed.ltx <- bench.summary.speed.sel[2:length(bench.summary.speed.sel)]
rownames(bench.summary.speed.ltx) <- bench.summary.speed.sel$variable
colnames(bench.summary.speed.ltx) <- sapply(colnames(bench.summary.speed.ltx), function(x) {sedit(x, '_', ' ')})



# LaTeX table, timings
(function() {
  len <- length(bench.summary.ltx)/2
  out <- latex(bench.summary.ltx,
               file=paste0(input.basename, "-timings.tex"),
               rowlabel="Benchmark",
               booktabs=TRUE,
               table.env=FALSE, center="none",
               size="footnotesize", #center="centering",
               colheads=rep(c('mean', 'error'), len),
               col.just=rep(c('r','@{\\,\\si{\\milli\\second} \\ensuremath{\\pm}}r'), len),
               cgroup=levels(droplevels(bench.summary.raw$VMshort)),
               cdec=rep(3, len*2)
              )
})()

# LaTeX table, speed
(function() {
  len <- length(bench.summary.speed.ltx)/2
  out <- latex(bench.summary.speed.ltx,
               file=paste0(input.basename, "-speed.tex"),
               rowlabel=" ",
               booktabs=TRUE,
               table.env=FALSE, center="none",
               size="footnotesize", #center="centering",
               colheads=rep(c('mean', 'error'), len),
               #col.just=rep(c('r','@{ BC/sec}', 'r', '@{ send/sec}'), len/2),
               cgroup=levels(droplevels(bench.summary.speed.raw$VMshort)),
               cdec=rep(0, len*2)
  )
})()
#
# EOF
#
