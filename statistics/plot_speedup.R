# Plot speedup/core graph
plot.speedup.core <- function(dataset, name, workload, schedule="dynamic", max.cores=50, plot.optimal=TRUE, plot.regression=FALSE) {

	# plot dataset
	plot(
		dataset[,c("cores", "speedup")],
		#main = paste(name, " benchmark\n", workload, "workload, ", schedule, " scheduling", sep = ""),
		xlab = "cores",
		ylab = "speedup",
		xlim = c(0, max.cores),
		ylim = c(0, max.cores)
	)

	# plot optimal speedup
	if (plot.optimal) {
		abline(a = 0, b = 1, col = "blue")
	}

	# plot regression
	if (plot.regression) {
		regression <- lm(formula = dataset$speedup ~ dataset$cores + I(dataset$cores^2))
		kk <- coefficients(regression)
		coefs <- c(kk[[1]], kk[[2]], kk[[3]])
		curve(coefs[1] + coefs[2]*x + coefs[3]*x^2, add=TRUE)

		#	regression <- lm(formula = dataset[, "speedup"] ~ dataset[, "cores"] + sqrt(dataset[, "cores"]))
		#	kk <- coefficients(regression)
		#	coefs <- c(kk[[1]], kk[[2]], kk[[3]])
		#	curve(coefs[1] + coefs[2]*x + coefs[3]*sqrt(x), add=TRUE)
	}
}

# Plot speedup/workload graph
plot.speedup.workload <- function(dataset, name, cores, schedule="dynamic", max.workload=10000, plot.optimal=TRUE, plot.regression=FALSE) {

	# plot dataset
	plot(
		dataset[,c("workload", "speedup")],
		#main = paste(name, " benchmark\n", cores, " cores, ", schedule, " scheduling", sep = ""),
		xlab = "workload",
		ylab = "speedup",
		xlim = c(0, max.workload),
		ylim = c(0, cores)
	)

	# plot optimal speedup
	if (plot.optimal) {
		abline(a = cores, b = 0, col = "blue")
	}

	# plot regression
	if (plot.regression) {
		regression <- lm(formula = dataset[, "speedup"] ~ dataset[, "workload"])
		curve(regression, add=TRUE, col="red")
	}
}

plot.boxplot <- function(dataset, name, cores, schedule="dynamic", from=6, to=8, plot.optimal=TRUE) {
	boxplot(
		speedup~workload,
		data=dataset,
		#main = paste(name, " benchmark\n", cores, " cores, ", schedule, " scheduling", sep = ""),
		xlab = "workload",
		ylab = "speedup",
		ylim = c(from, to)
	)

	# plot optimal speedup
	if (plot.optimal) {
		abline(a = cores, b = 0, col = "blue")
	}

}
