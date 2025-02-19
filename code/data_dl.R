#' ---
#' title: 'Data Report: MAXYR Eastern Bering Sea continental shelf Bottom Trawl Survey of Groundfish and Invertebrate Fauna'
#' author: 'L. Britt, E. H. Markowitz, E. J. Dawson, and R. Haehn'
#' purpose: Download data
#' start date: 2021-03-03
#' date modified: 2021-09-01        # CHANGE
#' Notes:                             # CHANGE
#' ---

# This has a specific username and password because I DONT want people to have access to this!
# source("C:/Users/emily.markowitz/Work/Projects/ConnectToOracle.R")
# source("C:/Users/emily.markowitz/Documents/Projects/ConnectToOracle.R")
source("Z:/Projects/ConnectToOracle.R")

# I set up a ConnectToOracle.R that looks like this: 
#   
#   PKG <- c("RODBC")
# for (p in PKG) {
#   if(!require(p,character.only = TRUE)) {  
#     install.packages(p)
#     require(p,character.only = TRUE)}
# }
# 
# channel<-odbcConnect(dsn = "AFSC",
#                      uid = "USERNAME", # change
#                      pwd = "PASSWORD", #change
#                      believeNRows = FALSE)
# 
# odbcGetInfo(channel)

##################DOWNLOAD CPUE and BIOMASS EST##################################

locations<-c(
  # BIOMASS
  "HAEHNR.biomass_ebs_plusnw_safe",
  "HAEHNR.biomass_ebs_plusnw",
  "HAEHNR.biomass_ebs_plusnw_grouped",

  # CPUE
  "HAEHNR.cpue_nbs",
  "HAEHNR.cpue_ebs_plusnw",
  "HAEHNR.cpue_ebs_plusnw_grouped",

  # Size Comps - the extrapolated size distributions of each fish
  "HAEHNR.sizecomp_nbs_stratum",
  "HAEHNR.sizecomp_ebs_plusnw_stratum",
  # "HAEHNR.sizecomp_ebs_plusnw_stratum_grouped",
  
  # # CRAB
  # "crab.co_size1_cpuenum",
  # "crab.co_size1_cpuewgt", 
  # "crab.cb_size1_cpuenum",
  # "crab.cb_size1_cpuewgt",
  # "crab.rk_size1_cpuenum_leg1",
  # "crab.rk_size1_cpuewgt_leg1",
  # "crab.rk_size1_cpuenum_leg2",
  # "crab.rk_size1_cpuewgt_leg2",
  # "crab.rk_size1_cpuenum_leg3",
  # "crab.rk_size1_cpuewgt_leg3",
  # "crab.bk_size1_cpuenum",
  # "crab.bk_size1_cpuewgt",
  # "crab.co_size1_cpuenum_nbs",
  # "crab.co_size1_cpuewgt_nbs",
  # "crab.co_weight_mt_size1_union_nbs",
  # "crab.co_num_size1_union_nbs",
  # "crab.bk_size1_cpuenum_nbs",
  # "crab.bk_size1_cpuewgt_nbs",
  # "crab.bk_weight_mt_size1_union_nbs",
  # "crab.bk_num_size1_union_nbs",
  # "crab.rk_size1_cpuenum_nbs",
  # "crab.rk_size1_cpuewgt_nbs",
  
  # #General Tables of data
  "RACEBASE.CATCH",
  # "RACE_DATA.HAULS", # For vessel net mens. codes
  "RACEBASE.HAUL",
  "RACE_DATA.V_CRUISES",
  "RACE_DATA.V_EXTRACT_FINAL_LENGTHS", # the number of fish physically by hand lengthed (not extrapolated into sizecomp)
  # "RACEBASE.LENGTH",
  "RACEBASE.SPECIMEN",
  "RACEBASE.STRATUM",
  # "RACEBASE.STATIONS",
  "RACEBASE.SPECIES",
  "RACEBASE.SPECIES_CLASSIFICATION",
  # "RACE_DATA.RACE_SPECIES_CODES",
  "RACE_DATA.VESSELS"#,
  # "RACE_DATA.TAXONOMIC_RANKS",
  # "RACE_DATA.SPECIES_TAXONOMIC"#,
  # # ADFG
  # "RACEBASE.LENGTH_ADFG",
  # "RACEBASE.SPECIMEN_ADFG"
  )


#sinks the data into connection as text file
sink("./data/metadata.txt")

print(Sys.Date())

for (i in 1:length(locations)){
  print(locations[i])
  if (locations[i] == "RACEBASE.HAUL") { # that way I can also extract TIME

    a<-RODBC::sqlQuery(channel, paste0("SELECT * FROM ", locations[i]))
    
    a<-RODBC::sqlQuery(channel, paste0("SELECT ",
                                       paste0(names(a)[names(a) != "START_TIME"], sep = ",", collapse = " "),
                                       " TO_CHAR(START_TIME,'MM/DD/YYYY HH24:MI:SS') START_TIME  FROM ", 
                                       locations[i]))
  } else {
    a<-RODBC::sqlQuery(channel, paste0("SELECT * FROM ", locations[i]))
  }
  write.csv(x=a, 
            paste0("./data/oracle/",
                   tolower(strsplit(x = locations[i], 
                                    split = ".", 
                                    fixed = TRUE)[[1]][2]),
                   ".csv"))
  remove(a)
}

sink()


