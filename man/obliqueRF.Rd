\name{obliqueRF}
\alias{obliqueRF}
\alias{obliqueRF.default}
\alias{print.obliqueRF}

\title{Classification with Oblique Random Forest}
\description{
  \code{obliqueRF} implements a random forest with oblique decision trees for binary classification tasks. Discriminative node models in the tree are based on: ridge regression, logistic regression, linear support vector machines, or random splits.
}
\usage{
\method{obliqueRF}{default}(
                    x,
                    y,
                    x.test=NULL,
                    y.test=NULL,
                    mtry=NULL,
                    ntree=100,
                    training_method="ridge",
                    bImportance = F,
                    bProximity = F,
                    verbose = F,
                    ...
                    )

}
\arguments{
  \item{x}{a data frame or a matrix of predictors; rows are samples, columns are featues}
  \item{y}{a binary response vector (numeric, factor); for now only binary classification problems are supported}
  \item{x.test}{optional: predictors of a test data set; if no test data set is given the training data set is used}
  \item{y.test}{optional: binary response vector of a test data set}
  \item{mtry}{the number of variables to be tested in each node; default is mtry = max(sqrt(ncol(x),2)}
  \item{ntree}{the number of trees to generate in the forest; default is ntree = 100}
  \item{training_method}{specify the node model; valid models are "ridge" for fast ridge regression using SVD, "ridge_slow" for a slower version using separate explicit ridge regressions, "pls" for partial least squares regression, "svm" for a linear support vector machine, "log" for logistic regression, "rnd" for a random hyperplane; hyperparameters for constrained methods are adapted to the oob data available at the node}
  \item{bImportance}{calculate the obliqueRF variable importance? default is FALSE; importance can only be calculated for unconstrained regression and sets training_method="log"; set ntree to a very large value}
  \item{bProximity}{calculate the obliqueRF sample proximity? default is FALSE; be aware that the proximity matrix scales with nrow(x)^2 and may require a prohibitive large amount of memory; set ntree to a very large value}
  \item{verbose}{print status messages?}
  \item{...}{not used}
}

\value{
  An object of class \code{obliqueRF}, which is a list with the
  following components:

  \item{call}{the original call to \code{obliqueRF}}
  \item{type}{for now only \code{classification}}
  \item{errs}{list with errors}
  \item{class_names}{class names referring to classes "0" and "1" in errs.}
  \item{pred}{list containing the prediction result}
  \item{lab}{description of the node training method}
  \item{ntree}{number of trees used}
  \item{mtry}{number of split variables}
  \item{importance}{a vector with the variable importances - or NULL, if the importance was not calculated}
  \item{proximity}{the variable proximity - or NULL, if the proximity was not calculated}
  \item{num_classes}{the number of classes}
  \item{trees}{the tree structure that was learned}
}

\details{
Subspace dimensionality mtry should be adjusted on a test set for optimal performance; ntree should be chosen sufficiently large.

Node models with constraint, i.e., ridge regression, partial least squares regression, linear support vector machine, are optimized in each split in a test on the out-of-bag samples available at that node. (Ridge and partial least squares regression are used without feature scaling, the support vector machine model scales feature.) Choose the logistic node model if a constrained fit is not desired or required. 

The obliqueRF importance counts how often a variable was deemed relevant (at .05 level) when chosen for a split at a node (increasing the importance value by 1) and how often it was irrelevant for the split (decreasing by 1). Significance is determined through ANOVA tables for the fitted logistic node model.

This is an R implementation, C code available from the authors upon request. 
}

\references{
  Menze BH, Kelm BM, Splitthoff DN, Koethe U, Hamprecht FA. On oblique random forests.  Proc ECML/PKDD 2011. LNCS 6911, 453-469 \url{http://people.csail.mit.edu/menze/papers/menze_11_oblique.pdf}.
}
\author{Bjoern Menze <menze@csail.mit.edu> and D.N. Splitthoff <nico.splitthoff@gmx.de>.}

\seealso{\code{\link{predict.obliqueRF}}, \code{\link{importance.obliqueRF}}}

\examples{
require(obliqueRF)
data(iris)

## data
# extract feature matrix
x<-as.matrix(iris[,1:4])
# convert to 0/1 class labels
y<-as.numeric(iris[,5]=="setosa")

## train
smp<-sample(1:nrow(iris), nrow(iris)/5)
obj <- obliqueRF(x[-smp,], y[-smp])

## test
pred <- predict(obj, x[smp,], type="prob")
plot(pred[,2],col=y[smp]+1,ylab="setosa probability")
table(pred[,2]>.5,y[smp])

## example: importance
imp<-rep(0,ncol(x))
names(imp)<-colnames(x)
numIterations<-2 #increase the number of iterations for better results, e.g., numIterations=100
for(i in 1:numIterations){
 obj<-obliqueRF(x,y, 
	training_method="log", bImportance=TRUE, 
	mtry=2, ntree=20)
 imp<-imp+obj$imp
 plot(imp,t='l', main=paste("steps:", i*20), ylab="obliqueRF importance")
}

}
\keyword{classif}% at least one, from doc/KEYWORDS
\keyword{tree}
