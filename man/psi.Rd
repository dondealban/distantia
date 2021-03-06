% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/psi.R
\name{psi}
\alias{psi}
\title{Computes sum of distances between consecutive samples in a multivariate time-series.}
\usage{
psi(
  least.cost = NULL,
  autosum = NULL,
  parallel.execution = TRUE)
}
\arguments{
\item{least.cost}{character string, name of the column with time/depth/rank data. The data in this column is not modified.}

\item{autosum}{dataframe with one or several multivariate time-series identified by a grouping column.}

\item{parallel.execution}{boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.}
}
\value{
A list with named slots, each one with a psi value.
}
\description{
Computes the sum of distances between consecutive samples in a multivariate time-series. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985). Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}.
}
\details{
The measure of dissimilarity \code{psi} is computed as: \code{least.cost - (autosum of sequences)) / autosum of sequences}. It has a lower limit at 0, while there is no upper limit.
}
\examples{

\donttest{
#loading data
data(sequenceA)
data(sequenceB)

#preparing datasets
AB.sequences <- prepareSequences(
 sequence.A = sequenceA,
 sequence.A.name = "A",
 sequence.B = sequenceB,
 sequence.B.name = "B",
 merge.mode = "complete",
 if.empty.cases = "zero",
 transformation = "hellinger"
 )

#computing distance matrix
AB.distance.matrix <- distanceMatrix(
 sequences = AB.sequences,
 grouping.column = "id",
 method = "manhattan",
 parallel.execution = FALSE
 )

#computing least cost matrix
AB.least.cost.matrix <- leastCostMatrix(
 distance.matrix = AB.distance.matrix,
 diagonal = FALSE,
 parallel.execution = FALSE
 )

AB.least.cost.path <- leastCostPath(
 least.cost.matrix = AB.least.cost.matrix,
 distance.matrix = AB.distance.matrix,
 parallel.execution = FALSE
 )

#extracting least cost
AB.least.cost <- leastCost(
 least.cost.path = AB.least.cost.path,
 parallel.execution = FALSE
 )

#autosum
AB.autosum <- autoSum(
 sequences = AB.sequences,
 least.cost.path = AB.least.cost.path,
 grouping.column = "id",
 parallel.execution = FALSE
 )
AB.autosum

AB.psi <- psi(
 least.cost = AB.least.cost,
 autosum = AB.autosum,
 parallel.execution = FALSE
 )
AB.psi

}

}
\author{
Blas Benito <blasbenito@gmail.com>

\itemize{
\item Birks, H.J.B.  and Gordon, A.D. (1985) Numerical Methods in Quaternary Pollen Analysis. Academic Press.
}
}
