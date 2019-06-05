#' Computes the dissimilarity measure \emph{psi} on two or more sequences.
#'
#' @description This workflow executes the following steps:
#' \itemize{
#' \item Computes the autosum of the sequences with \code{\link{autoSum}}.
#' \item Computes the distance matrix with \code{\link{distanceMatrix}}.
#' \item Uses the distance matrix to compute the least cost matrix with \code{\link{leastCostMatrix}}.
#' \item Extracts the cost of the least cost path with \code{\link{leastCost}}.
#' \item Computes the dissimilarity measure \emph{psi} with the function \code{\link{psi}}.
#' \item Delivers an output of type "list" (default), "data.frame" or "matrix", depending on the user input, through \code{\link{formatPsi}}.
#' }
#'
#' @usage workflowPsi(
#'   sequences = NULL,
#'   grouping.column = NULL,
#'   time.column = NULL,
#'   exclude.columns = NULL,
#'   method = "manhattan",
#'   diagonal = FALSE,
#'   format = "dataframe",
#'   parallel.execution = TRUE
#'   )
#'
#' @param sequences dataframe with multiple sequences identified by a grouping column generated by \code{\link{prepareSequences}}.
#' @param grouping.column character string, name of the column in \code{sequences} to be used to identify separates sequences within the file.
#' @param time.column character string, name of the column with time/depth/rank data.
#' @param exclude.columns character string or character vector with column names in \code{sequences} to be excluded from the analysis.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
#' @param diagonal boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path.
#' @param format string, type of output. One of: "data.frame", "matrix". If \code{NULL} or empty, a list is returned.
#' @param parallel.execution boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.
#'
#' @return A list, matrix, or dataframe, with sequence names and psi values.
#'
#' @author Blas Benito <blasbenito@gmail.com>
#'
#' @examples
#'
#' \dontrun{
#' data("sequencesMIS")
#' #prepare sequences
#' MIS.sequences <- prepareSequences(
#'   sequences = sequencesMIS,
#'   grouping.column = "MIS",
#'   if.empty.cases = "zero",
#'   transformation = "hellinger"
#'   )
#'
#'#execute workflow to compute psi
#'MIS.psi <- workflowPsi(
#'  sequences = MIS.sequences,
#'  grouping.column = "MIS",
#'  time.column = NULL,
#'  exclude.columns = NULL,
#'  method = "manhattan",
#'  diagonal = FALSE,
#'  output = "dataframe"
#'  )
#'
#'MIS.psi
#'
#'}
#'
#' @export
workflowPsi <- function(sequences = NULL,
                        grouping.column = NULL,
                        time.column = NULL,
                        exclude.columns = NULL,
                        method = "manhattan",
                        diagonal = FALSE,
                        format = "dataframe",
                        parallel.execution = TRUE){

  #autosum
  autosum.sequences <- autoSum(
    sequences = sequences,
    grouping.column = grouping.column,
    time.column = time.column,
    exclude.columns = exclude.columns,
    method = method,
    parallel.execution = parallel.execution
  )

  #computing distance matrix
  D <- distanceMatrix(
    sequences = sequences,
    grouping.column = grouping.column,
    time.column = time.column,
    exclude.columns = exclude.columns,
    method = method,
    parallel.execution = parallel.execution
  )

  #computing least cost matrix
  LC.matrix <- leastCostMatrix(
    distance.matrix = D,
    diagonal = diagonal,
    parallel.execution = parallel.execution
  )

  #getting least cost
  LC.value <- leastCost(
    least.cost.matrix = LC.matrix,
    parallel.execution = parallel.execution
  )

  #computing psi
  psi.value <- psi(
    least.cost = LC.value,
    autosum = autosum.sequences,
    parallel.execution = parallel.execution
    )

  #formating psi
  if(format != "list"){
    psi.value <- formatPsi(
      psi.values = psi.value,
      to = format
      )
  }

  return(psi.value)
}