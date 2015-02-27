setwd("~/Documents/masterthesis/statistics")

# For |-o-| have a look at http://monkeysuncle.stanford.edu/?p=485

draw.bar.plot <- function (data, cap=0, normalization=1, xlab="Execution times normalized to RPython", fun=min, set_back=1){
  data.min <- aggregate(data, list(data$n), FUN=fun)
  data.min <- data.min[,2:dim(data.min)[2]]
  data.rownames <- data.min[,c(1)]
  rownames(data.min) <- data.rownames
  # data.sd <- aggregate(data, list(data$n), FUN=sd)[,c(3, 4, 5)]
  # rownames(data.sd) <- data.rownames
  # data.sd
  all_but_first <- c(2:dim(data.min)[2])
  # data.min
  data.min.red <- data.min[,all_but_first]
  data.inverses <- (data.min.red/data.min.red[, normalization])
  
  if(cap == 0){
    cap <- max(data.inverses)
  }
  # some horzontal barplot of runtimes
  op <- par(las=1)
  bp.out <- barplot(t(data.inverses), beside=TRUE, horiz=TRUE, legend=colnames(data.min.red), xlab=xlab, 
          ylab="n", xlim=c(0, cap), xpd=FALSE)
  par(op)
  
  for (i in 1:dim(bp.out)[2]){
    for (j in 1:dim(bp.out)[1]){
      if(data.inverses[i, j] > cap){
        text(cap-set_back, bp.out[i*j], format(data.inverses[i, j], digits=3))
      }
    }
  }
  return(c(bp.out, data.inverses))
}

draw.line.plot <- function(data){
  # copy from quick-r
  # Create Line Chart
  # get the range for the x and y axis
  xrange <- range(data$n)
  yrange <- range(data$Smalltalk_cold)
  nlines <- dim(data)[2] - 1
  
  
  # set up the plot
  plot(xrange, yrange, type="n", xlab="n", ylab="Running time (ms)")
  
  linetype <- c(1:nlines)
  plotchar <- seq(18,18+nlines,1)
  
  # add lines
  for (i in 1:nlines) {
    lines(data$n, data[, i+1], type="b", lwd=1.5,
          lty=linetype[i], pch=plotchar[i])
  } 
  
  legend(xrange[1], yrange[2], colnames(data)[1:nlines+1], cex=0.8,
         pch=plotchar, lty=linetype)
}

data <- read.table("benchmark mixedRules 2013-08-10.csv", header=TRUE, sep=";")
head(data)
data <- data[, c(1, 5, 2, 4, 3)]

aggregate(data, list(data$n), FUN=min)[, 2:6]

bp.out <- draw.bar.plot(data, 33, xlab="Execution times normalized to C")
# dirty hack
text(23, bp.out[[20]], format(bp.out$Smalltalk_cold[5], digits=2))
text(23, bp.out[[16]], format(bp.out$Smalltalk_cold[4], digits=2))
title("BitBlt")

draw.line.plot(data)
# add a title and subtitle
title("Linearity of BitBlt Benchmark in n")

# another draw
data <- read.table("benchmark fill 2013-08-08.csv", header=TRUE, sep=";")
head(data)
data <- data[, c(1, 2, 4, 3)]

op <- par(mar=c(5, 5, 4, 2), mgp=c(4, 1, 0))
bp.out <- draw.bar.plot(data)
par(op)
title("Filling an Array with a Constant Value")

draw.line.plot(data)

# data <- read.table("benchmark replace 2013-08-09.csv", header=TRUE, sep=";")
# head(data)
# data <- subset(data, data$n > 10)
# data <- data[, c(1, 2, 3, 4)]
# 
# data.inverses <- draw.bar.plot(data)
# title("Replacing String Parts from Parts of a Second String")

data.aggregate <- data.frame()
data.absolute <- data.frame()
data.row.names <- c()
meta <- rbind(c("benchmark mixedRules 2013-08-10.csv", function (data){colnames(data) <- c("n", "RPython", "ST", "Smalltalk", "C");return(data[, c(1, 5, 4)])}, "BitBlt SPy"),
              c("benchmark mixedRules 2013-08-13 CogVM.csv", function (a) a, "BitBlt Cog"),
              c("benchmark mixedRules 2013-08-13 InterpreterVM.csv", function (a) a, "BitBlt Int"),
              c("benchmark replace 2013-08-09.csv", function (a){colnames(data) <- c("n", "C", "ST", "Smalltalk"); return(data[, c(1, 2, 4)])}, "Replace SPy"),
              c("benchmark replace 2013-08-13 CogVM.csv", function (a) a, "Replace Cog"),
              c("benchmark replace 2013-08-13 InterpreterVM.csv", function (a) a[, c(1, 2, 3)], "Replace Int"),
              c("benchmark fill 2013-08-08.csv", function (a){colnames(data) <- c("n", "C", "ST", "Smalltalk"); return(data[, c(1, 2, 4)])}, "Fill SPy"),
              c("benchmark fill 2013-08-13 CogVM.csv", function (a) a, "Fill Cog"),
              c("benchmark fill 2013-08-13 InterpreterVM.csv", function (a) a, "Fill Int"))
for(info in 1:dim(meta)[1]){
  print(meta[[info, 3]])
  data <- read.table(meta[[info, 1]], header=TRUE, sep=";")
  data <- meta[[info, 2]](data)
  data.inverse <- draw.bar.plot(data)
  data.inverse <- cbind(data.inverse$C, data.inverse$Smalltalk)
  n <- dim(data.inverse)[1]
  data.aggregate <- rbind(data.aggregate, data.inverse[n,])
  data.row.names <- c(data.row.names, meta[[info, 3]])

  data.absolute <- rbind(data.absolute, aggregate(data, list(data$n), FUN=min)[3:4][n,])
}
rownames(data.aggregate) <- data.row.names
rownames(data.absolute) <- data.row.names
data.aggregate
data.absolute

cap <- 64
par(mar=c(5,5,4,2))
bp.out <- barplot(t(data.aggregate), beside=TRUE, horiz=TRUE, legend=c("C/RPython", "Smalltalk"), 
        xlab="Execution times normalized to C/RPython", xlim=c(0, cap), xpd=FALSE, args.legend=list(x="bottomright"),
        las=1)
for (i in 1:dim(bp.out)[2]){
  for (j in 1:dim(bp.out)[1]){
    if(data.aggregate[i, j] > cap){
      text(cap-2, bp.out[i*j], format(data.aggregate[i, j], digits=3))
    }
  }
}
title("Relative Speed-up by Primitive Implementation in Different VMs")

# in order to be able to see the difference between C Cog and C SPy
data <- read.table("benchmark mixedRules 2013-08-13 InterpreterVM.csv", header=TRUE, sep=";")
aggregate(data, list(data$n), FUN=min)[2:4]
data <- read.table("benchmark mixedRules 2013-08-13 CogVM.csv", header=TRUE, sep=";")
aggregate(data, list(data$n), FUN=min)[2:4]
data <- read.table("benchmark mixedRules 2013-08-10.csv", header=TRUE, sep=";")
data <- data[, c(1, 5, 2, 4, 3)]
aggregate(data, list(data$n), FUN=min)[, 2:6]
