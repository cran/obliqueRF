\name{predict.obliqueRF}
\alias{predict.obliqueRF}
\title{predict method for oblique random forest objects}
\description{
  Prediction of test data using oblique random forest.
}
\usage{
\method{predict}{obliqueRF}(object, newdata, type="response", proximity=F,...)
}
\arguments{
  \item{object}{an object of class \code{obliqueRF}, as that
    created by the function \code{obliqueRF}.}
  \item{newdata}{a matrix containing new data.}
  \item{type}{one of \code{response}, \code{prob}. or \code{votes},
  indicating the type of output: predicted values, matrix of class
  probabilities, or matrix of vote counts.}
  \item{proximity}{should proximity measures be computed (based on all data)?}
  \item{...}{not used currently.}}

\value{
  \code{pred}, which can be the following, depending on \code{type}:
  \item{response}{ \code{pred} is a vector with predicted classes (threshold is 0.5).}
  \item{prob}{ \code{pred} is a matrix of class probabilities (one row for each class
  and one column for each input).}
  \item{votes}{ \code{pred} is a matrix of vote counts (one row for each class
  and one column for each new input).}
 
  If \code{proximity=TRUE}, the returned object is a list with two components: \code{pred} is the prediction (as described above) and \code{proximity} is the proximitry matrix.
}

\references{
  Menze BH, Kelm BM, Splitthoff DN, Koethe U, Hamprecht F. On oblique random forests.  Proc ECML/PKDD 2011. LNAI, 16p. \url{http://people.csail.mit.edu/menze/papers/menze_11_oblique.pdf}.
}
\author{Bjoern Menze <menze@csail.mit.edu> and D.N. Splitthoff <nico.splitthoff@gmx.de>.}

\seealso{\code{\link{obliqueRF}}}

\examples{
## Classification:
require(obliqueRF);
data(iris);
#sample some cases
s<-sample(150,100);
#extract feature matrix
x_train<-as.matrix(iris[s,1:4]);
#convert to 0/1 class labels
y_train<-(as.numeric(iris[s,5])>1)*1;
iris.orf <- obliqueRF(x_train,y_train);

#extract feature matrix
x<-as.matrix(iris[-s,1:4]);
#convert to 0/1 class labels
y<-(as.numeric(iris[-s,5])>1)*1;
pred <- predict(iris.orf,x,type="response",proximity=TRUE);
sum(pred$pred!=y)
}
\keyword{classif}% at least one, from doc/KEYWORDS
\keyword{regression}
