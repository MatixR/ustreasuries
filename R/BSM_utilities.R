## ====================================================
## Black Scholes Merton for R (from Python)
## Written by George Fisher
## see https://github.com/grfiv/BlackScholesMerton
##
## Translated by Pratik K. Biswas on 1/25/2015
## ====================================================

## ===================================
##          UTILITIES
## ===================================

#' Numerical Derivation of the Standard Normal CDF
#'
#' Equivalent to the R function \emph{pnorm}
#'
#' @param x real number
#' @return N(x)
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @export
phi <- function(x) {
  # constants
  a1 <-  0.254829592
  a2 <- -0.284496736
  a3 <-  1.421413741
  a4 <- -1.453152027
  a5 <-  1.061405429
  p  <-  0.3275911

  # Save the sign of x
  sign = 1
  if (!is.nan(x) && x < 0) sign = -1
  x <- abs(x)/sqrt(2.0)

  # A&S formula 7.1.26
  t <- 1.0/(1.0 + p*x)
  y <- 1.0 - (((((a5*t + a4)*t) + a3)*t + a2)*t + a1)*t*exp(-x*x)

  return (0.5*(1.0 + sign*y))
}

#' N: the Standard Normal CDF
#'
#' Equivalent to the R function \emph{pnorm}
#'
#' Created numerically using the internal function \emph{phi}
#'
#' @note same function provided by \emph{en, N}
#'
#' @inheritParams phi
#' @aliases en N
#' @return N(x)
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#' @examples
#' for (x in seq(from=-5, to=5, by=0.1)) {
#'    print(paste(x, en(x), pnorm(x), all.equal(en(x), pnorm(x), tolerance=0.01)))
#'     }
#'
#' @export
en <- function(x) {
  return (phi(x))
}

#' N': the first derivative of N(x) ... the Standard Normal PDF
#'
#' Equivalent to the R function \emph{dnorm}
#'
#' @note same function provided by \emph{nprime, Nprime, enprime}
#' @inheritParams phi
#' @aliases nprime Nprime enprime
#' @return N'(x)
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @export
nprime <- function(x) {
    return(exp(-0.5 * x * x) / sqrt(2 * 3.1415926))
}

#' Produces a standard normal random variable 'epsilon'
#'
#' Random number from a Gausiian distribution
#' @importFrom stats pnorm dnorm rnorm
#' @return epsilon in N(0, 1)
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
RandN <- function() {
    nD <- rnorm(1000, 0, 1)
    return(sample(nD,1))
}

#' Produces a standard normal random normal variable epsilon times sigma*sqrt(deltaT)
#'
#' random number from a Gausiian distribution with variance ssdt
#' @param ssdt variance
#' @return epsilon in N(0, ssdt)
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
RandN_ssdt <- function(ssdt) {
    nD <- rnorm(1000, 0, ssdt)
    return(sample(nD,1))
}

#' Binomial tree risk-neutral probability
#'
#' @param Interest r, the risk-free rate; the asset's expected yield
#' @param Yield q, the asset's actual yield
#' @param sigma the asset's price volatility
#' @param deltaT time interval
#' @return p, the risk-neutral probability
#' @references
#' Hull 7th edition Ch 19 P 409
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @export
RiskNeutralProb <- function(Interest, Yield, sigma, deltaT) {

    u <- exp( sigma * sqrt(deltaT))
    d <- exp(-sigma * sqrt(deltaT))
    a <- exp((Interest - Yield) * deltaT) # growth factor
    numerator <- a - d
    denominator <- u - d

    return (numerator / denominator)
}

#' Call prices derived from put-call parity
#' @inheritParams dOne
#' @param Put_price the price of the put option to convert
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#' @examples
#' # Hull 7th edition Ch 17 P 357
#' library(ustreasuries)
#' Stock    <- 49      # S_0
#' Exercise <- 50      # K
#' Time     <- 20/52   # T
#' Interest <- 0.05    # r
#' Yield    <- 0#0.13  # q
#' sigma    <- 0.20
#'
#' EC = EuroCall(Stock, Exercise, Time, Interest, Yield, sigma)
#' EP = EuroPut(Stock, Exercise, Time, Interest, Yield, sigma)
#'
#' PC = CallParity(Stock, Exercise, Time, Interest, Yield, EP)
#' PP = PutParity(Stock, Exercise, Time, Interest, Yield, EC)
#'
#' writeLines(paste0("European Call Price: ", EC, "\n",
#'                   "Call Parity Price:   ", PC, "\n",
#'                   "Difference:          ", EC-PC, "\n\n",
#'
#'                   "European Put Price:  ", EP, "\n",
#'                   "Put Parity Price:    ", PP, "\n",
#'                   "Difference:          ", EP-PP))
#' @export
CallParity <- function(Stock, Exercise, Time, Interest, Yield, Put_price) {
    return (Put_price + Stock * exp(-Yield * Time) - Exercise * exp(-Interest * Time))
}

#' Put prices derived from put-call parity
#' @param Call_price the price of the call option to convert
#' @inheritParams dOne
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#' @examples
#' # Hull 7th edition Ch 17 P 357
#' library(ustreasuries)
#' Stock    <- 49      # S_0
#' Exercise <- 50      # K
#' Time     <- 20/52   # T
#' Interest <- 0.05    # r
#' Yield    <- 0.13#0  # q
#' sigma    <- 0.20
#'
#' EC = EuroCall(Stock, Exercise, Time, Interest, Yield, sigma)
#' EP = EuroPut(Stock, Exercise, Time, Interest, Yield, sigma)
#'
#' PC = CallParity(Stock, Exercise, Time, Interest, Yield, EP)
#' PP = PutParity(Stock, Exercise, Time, Interest, Yield, EC)
#'
#' writeLines(paste0("European Call Price: ", EC, "\n",
#'                   "Call Parity Price:   ", PC, "\n",
#'                   "Difference:          ", EC-PC, "\n\n",
#'
#'                   "European Put Price:  ", EP, "\n",
#'                   "Put Parity Price:    ", PP, "\n",
#'                   "Difference:          ", EP-PP))
#'
#' @export
PutParity <- function(Stock, Exercise, Time, Interest, Yield, Call_price) {
    return (Call_price + Exercise * exp(-Interest * Time) - Stock * exp(-Yield * Time))
}

#' Forward price
#'
#' The delivery price in a forward contract that causes the contract to be worth zero.
#'
#' @param Spot S_0, the spot price of the asset
#' @param Time T, the time to maturity
#' @param Interest r, the risk-free rate
#' @param Yield q, asset yield with continuous compounding
#' @param Income I, the PV of an asset's income
#' @return the forward price
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' library(ustreasuries)
#' # Hull 7th edition Ch 5 P 103
#' Spot     <- 40
#' Time     <- 0.25
#' Interest <- 0.05
#' Yield    <- 0
#' Income   <- 0
#' ForwardPrice(Spot, Time, Interest, Yield, Income)
#'
#' # Hull 7th edition Ch 5 P 105
#' Spot     <- 900
#' Time     <- 0.75
#' Interest <- 0.04
#' Yield    <- 0
#' Income   <- 40 * exp(-0.03 * 4/12) # PV(40) = 39.60
#' ForwardPrice(Spot, Time, Interest, Yield, Income)
#'
#' # Hull 7th edition Ch 5 P 107
#' Spot     <- 25
#' Time     <- 0.50
#' Interest <- 0.10
#'
#' # convert 0.04 discrete to continuous
#' Yield_d  <- 0.04
#' Yield    <- r_continuous(Yield_d, 2)
#'
#' Income   <- 0
#' ForwardPrice(Spot, Time, Interest, Yield, Income)
#'
#' @references
#' Hull 7th edition Ch 5 P 103-108
#'
#' @export
ForwardPrice <- function(Spot, Time, Interest, Yield, Income) {
    return ((Spot - Income) * exp((Interest - Yield) * Time))
}

#' Forward rate
#'
#' The rate of interest for a period of time in the future implied by today's zero rates.
#' (discrete compounding)
#'
#' @param SpotInterest1 the zero rate for Time 1
#' @param Time1 starting time
#' @param SpotInterest2 the zero rate for Time 2
#' @param Time2 ending time
#' @return forward rate of inteest
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @export
ForwardRate <- function(SpotInterest1, Time1, SpotInterest2, Time2) {
    numerator   <- (1 + SpotInterest2) ** Time2
    denominator <- (1 + SpotInterest1) ** Time1
    return (((numerator / denominator) ** (1 / (Time2 - Time1))) - 1)
}

#' Compound Annual Growth Rate
#'
#' \itemize{
#'     \item \bold{geometric} FV = PV * (1 + geometric) ** years
#'     \item \bold{continuous} FV = PV * exp(continuous * years)
#'  }
#'
#' @note see \emph{r_continuous} and \emph{r_discrete}
#' @param PV the price at the beginning of the period
#' @param FV the price at the end of the period
#' @param fractional_years the length of the period in (fractional) years
#' @param type either "geometric" or "continuous"
#' @return the compounded rate of return, annualized
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' PV    <- 9000
#' FV    <- 13000
#' years <- 3
#' (geometric  <- CAGR(9000, 13000, years, type="geometric"))
#' (continuous <- CAGR(9000, 13000, years, type="continuous"))
#' 9000 * (1 + geometric) ** years
#' 9000 * exp(continuous * years)
#'
#' \dontrun{
#' error <- CAGR(9000, 13000, years, type="error")}
#'
#' @export
CAGR <- function(PV, FV, fractional_years, type="geometric") {
    if (type == "geometric")
        return (((FV / PV) ** (1 / fractional_years)) - 1)

    if (type == "continuous")
        return (log(FV / PV) / fractional_years)

    stop('CAGR takes type = ["geometric" | "continuous"]')
}

#' Convert TO continuous compounding FROM discrete
#' @param r_d the discrete CAGR returned from \emph{CAGRd}
#' @param compounding_periods_per_year how often the rate is compounded (2 => semiannual)
#' @return the continuously-compounded rate of return
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' # Hull 7th edition Ch 5 P 107
#' r_d                          <- 0.04
#' compounding_periods_per_year <- 2
#' ans <- r_continuous(r_d, compounding_periods_per_year)
#' writeLines(paste0(round(ans,4)))

#'
#' @export
r_continuous <- function(r_d, compounding_periods_per_year) {
    m = compounding_periods_per_year
    return (m * log(1 + r_d / m))
}

#' Convert TO discrete compounding FROM continuous
#'
#' @note
#' FV = PV * (1 + discrete / freq) ** (freq * years)
#'
#' FV = PV * exp(continuous * years)
#'
#' @param r_c the continuously compounded rate of return
#' @param freq how often the discrete rate is compounded (2 => semiannual)
#' @return the discrete rate of return
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#' @examples
#' PV    <- 9000
#' FV    <- 13000
#' years <- 3
#' freq  <- 2   # compounding frequency = 2 => semi-annual
#'
#' (r_continuous <- CAGR(PV, FV, years, type="continuous"))
#' (r_discrete   <- r_discrete(r_continuous, freq))
#'
#' PV * (1 + r_discrete / freq) ** (freq * years)
#'
#' PV * exp(r_continuous * years)
#'
#' @export
r_discrete <- function(r_c, freq) {
    m = freq
    return (m * (exp(r_c / m) - 1))
}

#' Calculate discount factor Z(t, T)
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#' @param annual_rate the compounded annual rate of interest
#' @param years number of (fractional) years
#' @param pmt_freq frequency of compounding (optional)
#' \itemize{
#'     \item numeric => discrete compounding (2 => semi annual)
#'     \item Inf => continuous compounding (default)
#'     }
#' @return Z(t, T)
#' @references Veronesi Ch2 P29-38
#' @examples
#' PV    <- 9000
#' FV    <- 13000
#' years <- 3
#' freq  <- 2   # compounding frequency = 2 => semi-annual
#'
#' (continuous <- CAGR(PV, FV, years, type="continuous"))
#' (discrete   <- r_discrete(continuous, freq))
#'
#' (df_continuous <- discount_factor(continuous,  years))
#'
#' (df_discrete   <- discount_factor(discrete,  years, freq))
#'
#' FV * df_continuous
#' FV * df_discrete
#'
#' all.equal(df_continuous, df_discrete) # df_continuous == df_discrete
#'
#' @export
discount_factor <- function(annual_rate,  years, pmt_freq = Inf) {
    # continuous compounding
    if (pmt_freq == Inf) {
        return(exp(-annual_rate * years))
    }

    # periodic compounding
    return(1 / ( (1 + annual_rate / pmt_freq) ** (pmt_freq * years) ))
}

#' Calculate annualized interest rate r(t, T) from a discount factor Z(t, T)
#'
#' @param d_f discount factor Z(t, T)
#' @param years number of (fractional) years: period that the discount factor
#' effects
#' @param pmt_freq frequency of compounding (optional)
#' \itemize{
#'     \item numeric => discrete compounding (2 => semi annual)
#'     \item Inf => continuous compounding (default)
#'     }
#' @return r(t, T)
#' @references Veronesi Ch2 P29-38
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#' @examples
#' PV    <- 9000
#' FV    <- 13000
#' years <- 3
#' freq  <- 2   # compounding frequency = 2 => semi-annual
#'
#' # continuous interest rate
#' # ========================
#' (r_continuous  <- CAGR(PV, FV, years, type="continuous"))
#' (df_continuous <- discount_factor(r_continuous,  years))
#' (c_ir          <- interest_rate(df_continuous, years))
#' all.equal(r_continuous, c_ir)
#'
#' # discrete interest rate
#' # ======================
#' (r_discrete  <- r_discrete(r_continuous, freq))
#' (df_discrete <- discount_factor(r_discrete,  years, freq))
#' (d_ir        <- interest_rate(df_discrete,   years, freq))
#' all.equal(r_discrete,   d_ir)
#'
#' @export
interest_rate <- function(d_f, years, pmt_freq = Inf) {
    # continuous compounding
    if (pmt_freq == Inf) {
        return(-log(d_f) / years)
    }

    # periodic compounding
    return(pmt_freq * ((1 / (d_f**(1 / (pmt_freq * years)))) - 1))
}

#' Intrinsic value of a call option
#'
#' The in-the-money portion of the option's premium
#'
#' @param Stock S_0, the asset price
#' @param Exercise K, the option strike price
#' @return max(Stock - Exercise, 0)
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' # Investopia: Intrinsic Value
#' # http://www.investopedia.com/terms/i/intrinsicvalue.asp
#' Stock    <- 25 # S_0
#' Exercise <- 15 # K
#' IntrinsicValueCall(Stock, Exercise) # 10
#'
#' @export
IntrinsicValueCall <- function(Stock, Exercise) {
    return(max(Stock - Exercise, 0))
}

#' Intrinsic value of a put option
#'
#' The in-the-money portion of the option's premium
#'
#' @inheritParams IntrinsicValueCall
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' # Investopia: Intrinsic Value
#' # http://www.investopedia.com/terms/i/intrinsicvalue.asp
#' Stock    <- 15 # S_0
#' Exercise <- 25 # K
#' IntrinsicValuePut(Stock, Exercise) # 10
#'
#' @export
IntrinsicValuePut <- function(Stock, Exercise) {
    return(max(Exercise - Stock, 0))
}

#' Is a call option in the money?
#'
#' Is the current market price of the asset above the strike price of the call?
#'
#' @inheritParams IntrinsicValueCall
#' @return IntrinsicValueCall(Stock, Exercise) > 0
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' # http://www.call-options.com/in-the-money.html
#' library(ustreasuries)
#' Stock    <- 37.75     # S_0
#' Exercise <- 35        # K
#'
#' InTheMoneyCall(Stock, Exercise)  # TRUE
#'
#' @export
InTheMoneyCall <- function(Stock, Exercise) {
    return(IntrinsicValueCall(Stock, Exercise) > 0)
}

#' Is a put option in the money?
#'
#' Is the current market price of the asset below the strike price of the put?
#'
#' @inheritParams IntrinsicValueCall
#' @return IntrinsicValuePut(Stock, Exercise) > 0
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' # http://www.call-options.com/in-the-money.html
#' library(ustreasuries)
#' Stock    <- 35        # S_0
#' Exercise <- 37.50     # K
#'
#' InTheMoneyPut(Stock, Exercise)  # TRUE
#'
#' @export
InTheMoneyPut <- function(Stock, Exercise) {
    return(IntrinsicValuePut(Stock, Exercise) > 0)
}

#' Time Value of a European Put Option
#'
#' The total value of an option is its intrinsic value plus its time value
#'
#' @inheritParams IntrinsicValuePut
#' @param Put_price The value of the put being analyzed
#' @return The Time Value of the put option
#' @references
#' Hull, 7th edition ch 8 p186
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' # Hull, 7th edition ch 8 p186
#' Stock      <- 21     # S_0
#' Exercise   <- 20     # K
#' Put_price <- 1.875
#'
#' (puttv <- TimeValuePut(Stock, Exercise, Put_price))
#'
#' @export
TimeValuePut <- function(Stock, Exercise, Put_price) {
    return(Put_price - IntrinsicValuePut(Stock, Exercise))
}

#' Time Value of a European Call Option
#'
#' The total value of an option is its intrinsic value plus its time value
#'
#' @inheritParams IntrinsicValueCall
#' @param Call_price The value of the call being analyzed
#' @return The Time Value of the call option
#' @references
#' Hull, 7th edition ch 8 p186
#'
#' @author George Fisher \email{GeorgeRFisher@gmail.com}
#'
#'
#' @examples
#' # Hull, 7th edition ch 8 p186
#' Stock      <- 21     # S_0
#' Exercise   <- 20     # K
#' Call_price <- 1.875
#'
#' (calltv <- TimeValueCall(Stock, Exercise, Call_price))
#'
#' @export
TimeValueCall <- function(Stock, Exercise, Call_price) {
    return(Call_price - IntrinsicValueCall(Stock, Exercise))
}

