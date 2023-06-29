
##################################################################################
# Author: Hung Vo (An Evaluator Analytics)
# Date: 3/10/2020
# 
# One script only
# Processed output data file is in data/mh_comm_data.csv
# The raw mental health performance reports Word doc are stored in /data
# The word document scraping syntax is not available; may release it in the future
##################################################################################

# load packages
library(tidyverse)
library(janitor)
library(docxtractr)
library(officer)
library(ggpubr)
library(ggstatsplot)

# ================= READ THE DATA FILE =================

# read in the processed output data file
mh_comm_data <- readr::read_csv(file = "./data/mh_comm_data.csv")

# ================= NEW CASE RATE LINE CHART: ADULT METRO COMMUNITY =================

# a few manipulations to ensure that we don't include subtotals
mh_comm_time <- mh_comm_data %>% 
    filter(mh_group == "Adult",
           mh_subgroup == "Metro",
           !health_service %in% c("TOTAL"),
           !catchment %in% c("TOTAL STATEWIDE*", "TOTAL STATEWIDE")) %>%
    filter(!str_detect(tolower(health_service), "total")) %>% 
    mutate(health_service = ifelse(str_detect(tolower(health_service), "excl ory"), "Total Metro", health_service))

# plot top 4 health services + Total Metro new case rate
adult_comm_qtr_nc_p <- ggplot(data = mh_comm_time,
       aes(x = period, y = new_case_rate, group = health_service, color = health_service)) + 
    geom_line() +
    gghighlight(health_service %in% c("Total Metro",
                                      "South West (Werribee)",
                                      "North East (Austin)",
                                      "Casey",
                                      "Peninsula")) +
    xlab("Period") +
    ylab("New Case Rate (%)") +
    theme_bw() +
    theme(plot.title = element_text(face = "bold"),
          plot.subtitle = element_text(face = "bold")) +
    labs(title = "New case rate (%) by Adult mental health community service across quarters",
         subtitle = "2019 20 Q3 and Q4 approximately covered the Victorian COVID-19 outbreaks",
         caption = "Source: Victorian Agency for Health Information (VAHI)
    Top 4 Adult mental health community service with highest Metropolitan new case rates are highlighted
    New case rate refers to \"Percentage of community cases open at any time during the 
    reference period which started during the reference period.\"
    
    Analysis: Hung Vo, An Evaluator Analytics")

# ================= CORRELATION 1: ADULT METRO COMMUNITY =================

# correlation between Adult community LoS and new cases percentage 
adult_comm_corr_p <- ggstatsplot::grouped_ggscatterstats(
    data = mh_comm_data %>% 
        filter(mh_group == "Adult",
               mh_subgroup == "Metro"),
    x = new_case_rate,
    y = average_length_of_case_days,
    point.color = health_service,
    grouping.var = period,
    point.alpha = 0.5,
    marginal = FALSE,
    bf.message = FALSE,
    title.prefix = "Period",
    title.text = "Relationship between length of case days and new case rate (%)
    Data for Adult Victorian metropolitan community mental health services",
    xlab = "New Case Rate (%)",
    ylab = "Avg. Length of Case (Days)",
    type = "pearson",
    centrality.parameter = "median",
    label.var = health_service,
    label.expression = new_case_rate > 40,
    caption.text = "Source: Victorian Agency for Health Information (VAHI)
    Each data point represents a single Adult Victorian metropolitan community mental health service
    Analysis: Hung Vo, An Evaluator Analytics"
) 

# ================= CORRELOGRAM: ADULT METRO COMMUNITY MEASURES =================

# list of measures first
adult_measures <- mh_comm_data %>% 
    filter(mh_group == "Adult",
           mh_subgroup == "Metro") %>% 
    select(pre_admission_contact_by_resp_amhs:average_change_in_clinically_significant_ho_nos_items) %>% 
    select_if(~sum(!is.na(.)) > 0) %>% 
    names() %>% 
    paste0("Var", seq(1:10), ": ", .)

# transform the community data
adult_comm_metro_data <- mh_comm_data %>% 
    filter(mh_group == "Adult",
           mh_subgroup == "Metro") %>% 
    select(period, pre_admission_contact_by_resp_amhs:average_change_in_clinically_significant_ho_nos_items) %>% 
    select_if(~sum(!is.na(.)) > 0) %>% 
    rename_at(vars(2:ncol(.)), ~ paste0("Var", seq(1:10)))

# producing the correlograms
adult_comm_corr_mat_p <- ggstatsplot::grouped_ggcorrmat(
    data = adult_comm_metro_data, 
    grouping.var = period,
    cor.vars = Var1:Var10,
    title.prefix = "Period",
    title.text = "Correlograms between Adult mental health commuity KPIs across quarters
    Data for Adult Victorian metropolitan community mental health services",
    caption.text = paste0("Source: Victorian Agency for Health Information (VAHI)\n",
                          paste(adult_measures[1:3], collapse = "; "), "\n",
                          paste(adult_measures[4:6], collapse = "; "), "\n",
                          paste(adult_measures[7:9], collapse = "; "), "\n",
                          paste(adult_measures[10], collapse = "; "), "\n",
    "Analysis: Hung Vo, An Evaluator Analytics")
) 
adult_comm_corr_mat_p

# ================= EXPORT IMAGES =================

# export the new cases over quarters plot
ggplot2::ggsave(filename = "output/adult_comm_qtr_nc_p.png",
                plot = adult_comm_qtr_nc_p,
                units = "in",
                width = 10,
                height = 8,
                dpi = 150)

# export the depression and anxiety plot
ggplot2::ggsave(filename = "output/adult_comm_corr_p.png",
                plot = adult_comm_corr_p,
                units = "in",
                width = 10,
                height = 12,
                dpi = 150)

# export the depression and anxiety plot
ggplot2::ggsave(filename = "output/adult_comm_corr_mat_p.png",
                plot = adult_comm_corr_mat_p,
                units = "in",
                width = 10,
                height = 12,
                dpi = 150)
