\name{importance}
\alias{importance}
\alias{importance.default}
\alias{importance.obliqueRF}
\title{Extract variable importance measure}
\description{
  This is the extractor function for variable importance measures as
  produced by \code{\link{obliqueRF}}.
}
\usage{
\method{importance}{obliqueRF}(x, ...)
}
\arguments{
  \item{x}{an object of class \code{\link{obliqueRF}}.}
  \item{...}{not used.}
}
\value{
  The variable importance
}
%\references{
%}
\seealso{
  \code{\link{obliqueRF}}
}
\examples{
## Classification:
require(obliqueRF);
data(iris);
#extract feature matrix
x<-as.matrix(iris[,1:4]);
#convert to 0/1 class labels
y<-(as.numeric(iris[,5])>1)*1;
iris.orf <- obliqueRF(x,y,training_method="log",bImportance=TRUE);
importance(iris.orf);
}
%\author{}
\keyword{regression}
\keyword{classif}
\keyword{tree}

