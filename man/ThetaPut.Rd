% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BSM.R
\name{ThetaPut}
\alias{ThetaPut}
\title{Theta of a European Put Option}
\usage{
ThetaPut(Stock, Exercise, Time, Interest, Yield, sigma)
}
\arguments{
\item{Stock}{S0, the initial stock price}

\item{Exercise}{K, the strike price}

\item{Time}{T, the time to maturity in fractional years}

\item{Interest}{r, the risk-free rate of return}

\item{Yield}{q, the dividend yield}

\item{sigma}{the asset volatility}
}
\value{
The Theta of the put option
}
\description{
Theta is the decay in the value of an option or a portfolio of options as time passes
}
\details{
In a delta-neutral portfolio, Theta is a proxy for Gamma
}
\note{
divide by 365 for "per calendar day"; 252 for "per trading day"
}
\examples{
# Hull, 7th edition Ch 17 p 367
library(ustreasuries)
Stock    <- 49     # S_0
Exercise <- 50     # K
Time     <- 20/52  # T
Interest <- 0.05   # r
Yield    <- 0      # q
sigma    <- 0.20

thcall <- ThetaCall(Stock, Exercise, Time, Interest, Yield, sigma)
thput  <- ThetaPut(Stock, Exercise, Time, Interest, Yield, sigma)

rKe    <- Interest * Exercise * exp(-Interest*Time)

writeLines(paste0("ThetaCall:        ", round(thcall, 2), "\\n",
                  "ThetaPut:         ", round(thput, 2),   "\\n",
                  "per calendar day: ", round(thput/365, 4), " (put)", "\\n",
                  "per trading day:  ", round(thput/252, 4), " (put)", "\\n\\n",
    "ThetaPut is always greater than ThetaCall by an amount rKe:", "\\n",
    "Diff: ",thput-thcall,"\\n",
    "rKe:  ",rKe))

}
\author{
George Fisher \email{GeorgeRFisher@gmail.com}
}
\references{
Hull, 7th edition ch 17 p367-368
}

