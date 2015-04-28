# import functions
source("load_data.R")
source("fix_data.R")
source("plot_speedup.R")
require(nortest)

# Usage:
# load dataset

################################## Fibonacci - sp/cpu

dataset1 <- load.dataset("data/result1.csv")

setEPS()
postscript("output/fib-1k-dyn.eps")
# Fibonacci speedup/cores - 1k workload, dynamic scheduling
Fibonacci.w1k.sd <- fix.workload.schedule(dataset1, name = "Fibonacci", workload = 1000, schedule = "dynamic")
plot.speedup.core(Fibonacci.w1k.sd, "Fibonacci", workload = 1000, schedule = "dynamic")
dev.off()

setEPS()
postscript("output/fib-20k-dyn.eps")
# Fibonacci speedup/cores - 20k workload, dynamic scheduling
Fibonacci.w20k.sd <- fix.workload.schedule(dataset1, name = "Fibonacci", workload = 20000, schedule = "dynamic")
plot.speedup.core(Fibonacci.w20k.sd, "Fibonacci", workload = 20000, schedule = "dynamic")
dev.off()

setEPS()
postscript("output/fib-20k-dyn-reg.eps")
# Fibonacci speedup/cores - 20k workload, dynamic scheduling
Fibonacci.w20k.sd <- fix.workload.schedule(dataset1, name = "Fibonacci", workload = 20000, schedule = "dynamic")
plot.speedup.core(Fibonacci.w20k.sd, "Fibonacci", workload = 20000, schedule = "dynamic", plot.regression = T)
dev.off()

setEPS()
postscript("output/fib-20k-dyn-resid.eps")
plot(resid(lm(formula = dataset$speedup ~ dataset$cores + I(dataset$cores^2))))
dev.off()

################################## Fibonacci sp/wl

dataset2 <- load.dataset("data/result1_wl.csv")

# Fibonacci speedup/workload - 8 cores, dynamic scheduling
setEPS()
postscript("output/fib-8c-dyn.eps")
Fibonacci.c8.sd <- fix.cores.schedule(dataset2, name = "Fibonacci", cores = 8, schedule = "dynamic")
plot.speedup.workload(Fibonacci.c8.sd, "Fibonacci", cores = 8, schedule = "dynamic", max.workload = 2000)
dev.off()

# Fibonacci speedup/workload - 24 cores, dynamic scheduling
setEPS()
postscript("output/fib-24c-dyn.eps")
Fibonacci.c24.sd <- fix.cores.schedule(dataset2, name = "Fibonacci", cores = 24, schedule = "dynamic")
plot.speedup.workload(Fibonacci.c24.sd, "Fibonacci", cores = 24, schedule = "dynamic", max.workload = 2000)
dev.off()

################################## Fibonacci distribution

dataset3 <- load.dataset("data/result1_norm.csv", aggr = FALSE)

setEPS()
postscript("output/fib-8c-dyn-box.esp")
normality8 <- fix.cores.schedule(dataset3, name = "Fibonacci", cores = 8, schedule = "dynamic")
plot.boxplot(normality8, name = "Fibonacci", cores = 8, schedule = "dynamic", from=5.8, to=8.2)
dev.off()

setEPS()
postscript("output/fib-24c-dyn-box.esp")
normality24 <- fix.cores.schedule(dataset3, name = "Fibonacci", cores = 24, schedule = "dynamic")
plot.boxplot(normality24, name = "Fibonacci", cores = 24, schedule = "dynamic", from=15, to=24)
dev.off()

##################################x
##################################x
##################################x

# boxplots
#setEPS()
#postscript("output/normality.eps")
normality8 <- fix.cores.schedule(dataset3, name = "Fibonacci", cores = 8, schedule = "dynamic")
normality8.1k <- normality8[normality8[,"workload"]==1000,]
normality8.10k <- normality8[normality8[,"workload"]==10000,]

normality24 <- fix.cores.schedule(dataset3, name = "Fibonacci", cores = 24, schedule = "dynamic")
normality24.1k <- normality24[normality24[,"workload"]==1000,]
normality24.10k <- normality24[normality24[,"workload"]==10000,]
#plot.single(normality, name = "ParallelFor", cores = 8, schedule = "dynamic")
#dev.off()

hist(normality8.1k[["speedup"]], breaks=10)
shapiro.test(normality8.1k[["speedup"]])
shapiro.test(normality8.10k[["speedup"]])

hist(normality24.1k[["speedup"]], breaks=10)
shapiro.test(normality24.1k[["speedup"]])
shapiro.test(normality24.10k[["speedup"]])

### Fibonacci 3D plot # regression
library(plot3D)
require(plot3D)

setEPS()
postscript("output/fib-reg-full.eps")
plot3D::scatter3D(
	rdataset$cores, rdataset$workload, rdataset$speedup,
	xlab='cores', ylab='workload', zlab='speedup',
	theta=320, phi=30
	#col='red'
)
dev.off()

setEPS()
postscript("output/fib-res-full.eps")
rdataset <- load.dataset('data/result_reg.csv', aggr=F)
rrr <- lm(rdataset$speedup ~ rdataset$cores + I(rdataset$cores^2) + I(rdataset$cores^4) + rdataset$workload + I(rdataset$workload^2))
plot(resid(rrr))
dev.off()

###################################### Master overhead

mdataset <- load.dataset("data/result_master.csv")

Master.w200.sd <- fix.workload.schedule(mdataset, name = "LevensteinMaster", workload = 200, schedule = "dynamic")
Master.w500.sd <- fix.workload.schedule(mdataset, name = "LevensteinMaster", workload = 500, schedule = "dynamic")
Master.w700.sd <- fix.workload.schedule(mdataset, name = "LevensteinMaster", workload = 700, schedule = "dynamic")
Master.w1000.sd <- fix.workload.schedule(mdataset, name = "LevensteinMaster", workload = 1000, schedule = "dynamic")

setEPS()
postscript("output/master-overhead.eps")

par(new=F)
plot(Master.w200.sd, xaxp  = c(2, 48, 23), col="red", ylim = c(0, 0.60))
par(new=T)
plot(Master.w500.sd, axes=F, col="darkgreen", ylim = c(0, 0.60))
par(new=T)
plot(Master.w700.sd, axes=F, col="blue", ylim = c(0, 0.60))
par(new=T)
plot(Master.w1000.sd, axes=F, ylim = c(0, 0.60))
par(new=F)

legend('topright', c('200', '500', '700', '1000'),
	   lty=1, col=c('red', 'darkgreen', 'blue', 'black'), bty='n')

dev.off()

###################################### Master overhead

sdataset <- load.dataset("data/result_master.csv")

Single.w200.sd <- fix.workload.schedule(sdataset, name = "LevensteinSingle", workload = 200, schedule = "dynamic")
Single.w500.sd <- fix.workload.schedule(sdataset, name = "LevensteinSingle", workload = 500, schedule = "dynamic")
Single.w700.sd <- fix.workload.schedule(sdataset, name = "LevensteinSingle", workload = 700, schedule = "dynamic")
Single.w1000.sd <- fix.workload.schedule(sdataset, name = "LevensteinSingle", workload = 1000, schedule = "dynamic")

setEPS()
postscript("output/single-overhead.eps")

par(new=F)
plot(Single.w200.sd, xaxp  = c(2, 48, 23), col="red", ylim = c(0, 0.60))
par(new=T)
plot(Single.w500.sd, axes=F, col="darkgreen", ylim = c(0, 0.60))
par(new=T)
plot(Single.w700.sd, axes=F, col="blue", ylim = c(0, 0.60))
par(new=T)
plot(Single.w1000.sd, axes=F, ylim = c(0, 0.60))
par(new=F)

legend('topright', c('200', '500', '700', '1000'),
	   lty=1, col=c('red', 'darkgreen', 'blue', 'black'), bty='n')

dev.off()

###################################### c++ comparison

cpp.1k <- load.cpp.dataset("data/result_cpp1k.csv", "data/cpp_serial_1k.csv")

setEPS()
postscript("output/cpp-comparison-1k.eps")

plot.speedup.core(Fibonacci.w1k.sd, "Fibonacci omp4j vs. C++", workload = 1000, schedule = "dynamic")
par(new=T)
plot(cpp.1k[c("cores", "speedup")], col="red", axes = F, xlim=c(0,50), ylim=c(0,50))
par(new=F)

legend('topleft', c('OpenMP', 'omp4j'), lty=1, col=c('red', 'black'), bty='n')

dev.off()

#######

cpp.20k <- load.cpp.dataset("data/result_cpp20k.csv", "data/cpp_serial_20k.csv")

setEPS()
postscript("output/cpp-comparison-20k.eps")

plot.speedup.core(Fibonacci.w20k.sd, "Fibonacci omp4j vs. C++", workload = 1000, schedule = "dynamic")
par(new=T)
plot(cpp.20k[c("cores", "speedup")], col="red", axes = F, xlim=c(0,50), ylim=c(0,50))
par(new=F)
legend('topleft', c('OpenMP', 'omp4j'), lty=1, col=c('red', 'black'), bty='n')

dev.off()

###################################### jomp comparison

jomp <- load.dataset("data/result_jomp.csv")

jomp.1k <- fix.workload.schedule(jomp, name="FibJOMP", workload=1000, schedule="dynamic")

setEPS()
postscript("output/jomp-comparison-1k.eps")

plot.speedup.core(Fibonacci.w1k.sd, "Fibonacci omp4j vs. JOMP", workload = 1000, schedule = "dynamic")
par(new=T)
plot(jomp.1k[c("cores", "speedup")], col="red", axes = F, xlim=c(0,50), ylim=c(0,50))
par(new=F)
legend('topleft', c('JOMP', 'omp4j'), lty=1, col=c('red', 'black'), bty='n')

dev.off()

####

jomp.20k <- fix.workload.schedule(jomp, name="FibJOMP", workload=20000, schedule="dynamic")

setEPS()
postscript("output/jomp-comparison-20k.eps")

plot.speedup.core(Fibonacci.w20k.sd, "Fibonacci omp4j vs. JOMP", workload = 20000, schedule = "dynamic")
par(new=T)
plot(jomp.20k[c("cores", "speedup")], col="red", axes = F, xlim=c(0,50), ylim=c(0,50))
par(new=F)
legend('topleft', c('JOMP', 'omp4j'), lty=1, col=c('red', 'black'), bty='n')

dev.off()

###################################### jomp tests

jomp.naggr <- load.dataset("data/result_jomp.csv", aggr=F)
jomp1k24c <- jomp.naggr[jomp.naggr$cores == 24 & jomp.naggr$workload == 1000, "speedup"]
jomp20k24c <- jomp.naggr[jomp.naggr$cores == 24 & jomp.naggr$workload == 20000, "speedup"]

omp4j.naggr <- load.dataset("data/result1.csv", aggr=F)
fib1k24c <- omp4j.naggr[omp4j.naggr$cores == 24 & omp4j.naggr$workload == 1000, "speedup"]
fib20k24c <- omp4j.naggr[omp4j.naggr$cores == 24 & omp4j.naggr$workload == 20000, "speedup"]

t.test(fib1k24c, jomp1k24c, alternative="less", paired=F)
