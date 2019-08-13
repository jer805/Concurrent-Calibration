#Concurrent calibration using item response theory

This vignette illustrates test equating of two short form medical diagnostic questionnaires using item response theory. The purpose here is primarly to illustrate how the equating process of concurrent calibration can be implemented using the mirt package in R, and to predict the scores on one survey from the other.

Test equating involves converting two psychometric surveys to a common scale so that scores can be compared between them. Normally test equating with item response theory involves a transformation equation using linking coefficients, which is analogous to slope and intercept parameters as used in linear regression. However, when two forms are designed to measure a common ability distribution, the parameters from both forms can also be estimated jointly from one dataset. A model for each form can then be estimated from those parameters to perform test equating, a process known as concurrent calibration.
