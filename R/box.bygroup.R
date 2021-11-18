#' Grouped jitter-boxplots
#'
#' This function creates a ggplot depicting the distribution of a numeric variable
#' within each group of a categorical variable. The data is displayed as boxplots
#' for each group overlapped by stripplots of all data points.
#'
#' @param df The data frame containing the columns to plot. This must be a data
#' frame containing the columns used for the numeric.var and group.var arguments.
#' @param numeric.var The numeric variable to plot. This parameter must be a
#' numeric column in df.
#' @param group.var The categorical variable to group by. This parameter can be
#' of any class and will be converted into a factor. To avoid warnings, the input
#'  must be a factor.
#' @param mytitle The optional title for the plot. Must be entered in quotation
#' marks. Defaults to blank if not specified.
#' @param numeric.lab The optional axis label for the numeric variable. Must be
#' entered in quotation marks. Defaults to blank if not specified.
#' @param group.lab The optional axis label for the grouping variable. Must be
#' entered in quotation marks. Defaults to blank if not specified.
#' @param point.alpha The optional value for the alpha transparency of the
#' jittered points.  Defaults to 0.5  if not specified.
#' @param mean.shape The optional entry to specify the geom shape for the mean
#' value using the numbers associated with each shape in ggplot. It defaults to
#' shape 4 which is an X.
#'
#' @return A ggplot object with layered boxplots and stripplots of the numeric
#' variable distribution within each of the groups of the categorical variable.
#' @details This is a plot to visualize group differences in a quantitative
#' variable. The boxplots provide statistical information and the stripplots show
#' the raw data values. In addition, an X is added to depict the mean for each
#' group. The stripplots are coloured by the grouping variable and alpha
#' transparency allows for visualization of overlapping points.
#' @examples
#' box.bygroup(iris, Sepal.Length, Species, mytitle = "Sepal length by species",
#' numeric.lab = "sepal length", group.lab = "species", point.alpha = 0.7, mean.shape = 3)
#'
#' #if the following example did not include as.factor() the function will work but produce a warning.
#' box.bygroup(ToothGrowth, len, as.factor(dose))
#' @export

box.bygroup <- function (df, numeric.var, group.var, mytitle = "", numeric.lab = "", group.lab = "", point.alpha = 0.5, mean.shape=4) {

  numeric.variable <- eval(substitute(numeric.var), df)
  group.variable <- eval(substitute(group.var), df)

  if(!is.numeric(numeric.variable)) {
    stop("The numeric.var parameter needs to be numeric. You have entered an object of class " , class(numeric.variable))
  }

  if(!is.factor(group.variable)) {
    warning("The group.var you have entered is not a factor. You have entered an object of class " , class(group.variable),
            " and it has been converted into a factor. Check to make sure this was the grouping variable you intended to specify.
            You can use as.factor() in the group.var argument to avoid this warning.")
  }

  if(!is.character(mytitle)) {
    stop("The mytitle parameter needs to be a character input (in quotation marks).
         You have provided an object of class: ", class(mytitle)[1])
  }

  if(!is.character(numeric.lab)) {
    stop("The numeric.lab parameter needs to be a character input (in quotation marks).
         You have provided an object of class: ", class(numeric.lab)[1])
  }

  if(!is.character(group.lab)) {
    stop("The group.lab parameter needs to be a character input (in quotation marks).
         You have provided an object of class: ", class(group.lab)[1])
  }

  if(NA %in% numeric.variable) {
    warning("The numerical variable has missing values.
            This plot has removed ", sum(is.na(numeric.variable)), " missing value(s).")
  }

  if(NA %in% group.variable) {
    warning("The grouping variable has missing values.
            This plot has removed ", sum(is.na(group.variable)), " missing value(s).")
  }

  myplot <- df %>%
    dplyr::filter(!is.na({{ numeric.var }})) %>%
    dplyr::filter(!is.na({{ group.var }})) %>%
    dplyr::mutate(group.variable := as.factor({{ group.var }})) %>%
    ggplot2::ggplot(ggplot2::aes(x = group.variable, y = {{ numeric.var }})) +
    ggplot2::geom_boxplot(outlier.shape = NA) +
    ggplot2::geom_jitter(ggplot2::aes(color = group.variable), alpha = point.alpha) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::labs(y= numeric.lab, x = group.lab, title = mytitle) +
    ggplot2::stat_summary(fun=mean, geom = "point", shape = mean.shape) +
    ggplot2::coord_flip()

  return(myplot)
}
