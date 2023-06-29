
# vic-mh-adult-comm-analysis

An analysis of the Victorian Adult mental health community services KPIs for 2019-20 Q1-Q4.

## Summary

Data for this analysis was retrieved from the Victorian Agency for Health Information (VAHI, 2020). There is summary information published but there are really limited KPIs reported.

The data was extracted from mental health performance report Word documents published on the health.vic.gov.au website using the `docxtractr` R package. I may write a tutorial on how I used this package to scrape the data from those Word documents in the future. Only the output file has been provided. 

For those interested, I'd recommend looking up the [GitHub repository](https://github.com/hrbrmstr/docxtractr) for the `docxtractr` R package.

## Purpose

The purpose of the analysis was to explore the available mental health performance KPIs and whether there were case volume related mental health demand. Furthermore, it was to see whether there were any relationships that existed with the identified relevant case-related KPIs.

## Usage

Run the `mh-comm-analysis.R`. This is the only script needed to run the analysis at this stage. Subject to change.

## Disclaimer

The underlying data is the official information published by VAHI. The analysis herewithin is only exploratory and to be informative only. For further information about the data and measures, please think about contacting the VAHI.

As this is exploratory, the data may not be completely transformed to the cleanest as one would expect. Use at your own risk.

## References

VAHI. (2020). Victorian health services performance - mental health. Retrieved from https://vahi.vic.gov.au/reports/victorian-health-services-performance/mental-health