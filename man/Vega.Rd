% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BSM.R
\name{Vega}
\alias{Vega}
\title{Vega of a European Option}
\usage{
Vega(Stock, Exercise, Time, Interest, Yield, sigma)
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
The Vega of the option
}
\description{
Vega is the sensitivity of an option price to changes in the volatility of the underlying asset
}
\details{
Vega is not a Greek letter, it is the brightest star in the constellation Lyra
}
\note{
if \code{abs(Vega)} is large, the option or portolio is very sensitive to changes in the volatility of the underlying asset
}
\examples{
# Hull, 7th edition Ch 17 p 375
library(ustreasuries)
Stock    <- 49     # S_0
Exercise <- 50     # K
Time     <- 20/52  # T
Interest <- 0.05   # r
Yield    <- 0      # q
sigma    <- 0.20

vega <- Vega(Stock, Exercise, Time, Interest, Yield, sigma)

writeLines(paste0("The value of Vega is ", round(vega,1),   "\\n",
"Therefore, a 1\% change in the volatility from 20\% to 21\%", "\\n",
"will raise the price of the option by this amount:",       "\\n",
"1\% x ", round(vega,1), " = ", round((0.01 * vega), 3),
", from ", Stock, " to ", Stock+round((0.01 * vega), 3)))

}
\author{
George Fisher \email{GeorgeRFisher@gmail.com}
}
\references{
Hull, 7th edition ch 17 p373-375
}

