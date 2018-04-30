---
title: "Introduction Fars package"
author: "Yohko TOMOTA"
date: "2018年4月30日"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Introduction Fars}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---





This is simple package to explore Fatality Analysis Reporting System (FARS) data from the National Highway Traffic Safety Administration.

## The data
***
This package contains 2013-2015 FASR's data as csv format. It lists the fatal car crashes in the United State for each year. Extra year's data also can be used with this package. In this case, files are not needed exactly same but should have columns of "MONTH","STATE","LONGITUD" and "LATITUDE". For more detail information about data, refer [NHTSA FARS](https://crashstats.nhtsa.dot.gov/#/DocumentTypeList/4)


## The functions
***
This package provide three function to users.  
 - `fars_read_years`  
 - `fars_summarize_years`  
 - `fars_map_state`  
 
This function includes following data ;

```r
list.files(system.file("extdata", package = "Fars"))
```

```
## [1] "accident_2013.csv.bz2" "accident_2014.csv.bz2" "accident_2015.csv.bz2"
```

### Reading FARS data
The function `fars_read_years` allows you to read FARS data into a list of data frame. It require `years` as argument, it can be single numeric or multiple vector.
For example, if you are interested in single year data,


```r
fars_read_years(years = 2013)
```

```
## Warning in value[[3L]](cond): invalid year: 2013
```

```
## [[1]]
## NULL
```

If you want to take 3 years data at a time, you can write:

```r
fars_read_years(years = 2013:2015)
```

```
## Warning in value[[3L]](cond): invalid year: 2013
```

```
## Warning in value[[3L]](cond): invalid year: 2014
```

```
## Warning in value[[3L]](cond): invalid year: 2015
```

```
## [[1]]
## NULL
## 
## [[2]]
## NULL
## 
## [[3]]
## NULL
```


### Summaring FARS data
The function `fars_summarize_years` counts the number of accident which recorded in each month. It takes  same argument with `fars_read_years` 


```r
fars_summarize_years(2013)
```

```
## Warning in value[[3L]](cond): invalid year: 2013
```

```
## Error in grouped_df_impl(data, unname(vars), drop): Column `year` is unknown
```

### Mapping accidents
The function `fars_map_state` display a state map plit including accidents location by year


```r
fars_map_state(1,2014)
```

```
## Error in fars_read(filename): file 'accident_2014.csv.bz2' does not exist
```

Apart from those function, following functions are used within this package, it would not be used by users directly.
 - `make_filenames` : to make path to data file
 - `fars_read` : to read in csv file 

