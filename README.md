# Dengue_model

--------------------------
# Dataset:

1. Global Climate Database.  
Monthly [min](https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tmin.zip), [max](https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tmax.zip), and [average](https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tavg.zip) temperature (°C)and [precipitation](https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_prec.zip) (mm) at various resolutions from 1970-2000 (Use 2.5 min spatial resolution data for 5 km) from [www.worldclim.org](https://www.worldclim.org/data/worldclim21.html)

2. [Global Aedes Distribution](https://www.dropbox.com/sh/bpxcmzmmpiiav8u/AAAl3CBKnBYwXb0n1s1C4-K-a?dl=0). 
Uncertainty estimates for mosquito distribution at 5 km x 5 km resolution (R datafiles and Aedes maps)
(Kraemer et al., 2015)

3. [Geolocalized Economic Data](https://gecon.yale.edu/data-and-documentation-g-econ-project).
Geophysically scaled dataset linking per capita gross product (GDP) at purchasing power parity (PPP) rates. The G-Econ project is gridded data set at a 1 degree longitude by 1 degree latitude resolution. This is approximately 100 km by 100 km.  

4. [Human Population Density](https://hub.worldpop.org/project/categories?id=18)  
We will use the Unconstrained individual countries 2000-2020 UN adjusted (1 km resolution). This will need to be changed to match the 5 km x 5 km resolution of the other data sets.

5. [CHC-CMIP6](https://www.chc.ucsb.edu/data)  
The CHC-CMIP6 dataset provides global, daily, high spatial resolution (0.05°) grids of observational and projected CHIRTS temperature, CHIRPS precipitation, ERA5-derived relative humidity, vapor pressure deficit (VPD), and maximum Wet Bulb Globe Temperatures (WBGTmax)

6. [Terrestrial Air Temperature and Precipitation: 1900-2014 Gridded Monthly Time Series](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html)  
    Long term monthly means, derived from data for years 1981 - 2010 V5.01. 0.5 degree latitude x 0.5 degree longitude global grid (720x360).

7. [CRU TS4.06: Climatic Research Unit (CRU) Time-Series (TS) version 4.06 of high-resolution gridded data of month-by-month variation in climate (Jan. 1901- Dec. 2021)](https://catalogue.ceda.ac.uk/uuid/e0b4e1e56c1c4460b796073a31366980)   
The gridded Climatic Research Unit (CRU) Time-series (TS) data version 4.06 data are month-by-month variations in climate over the period 1901-2021, provided on high-resolution (0.5x0.5 degree) grids, produced by CRU at the University of East Anglia and funded by the UK National Centre for Atmospheric Science (NCAS), a NERC collaborative centre.
--------------------------
# Missing values
<!-- We replace Somalia PPP2005_40 value with the lowest Djibouti PPP2005_40 value in Geolocalized Economic Data -->  
Replacing G-Econ data for countries with NA values in 2005 (PPP2005_40) with the corresponding values from 1990 (PPP1990_40).   

# Dengue Carrying Capacity model parameter settings for rainfall
![image](https://github.com/30-na/Dengue_model/assets/78888004/9f2c9b86-0770-44f8-bb74-291c90b6d5af)

where:
* c_briere = 7.86 * 10 ^ (-5)  
* z_briere = .28  
* c_quad = -5.99 * 10 ^ (-3)  
* z_quad = 0.025  
* z_inverse = 0.6  
* Rmin = 1
* Rmax_briere = 246
* Rmax_quad = 123  

# Dengue Model
![image](https://github.com/30-na/Dengue_model/assets/78888004/76afa7f0-3190-469c-8e0f-9516fad1fdf1)

# Alternative Model

![image](https://github.com/30-na/Dengue_model/assets/78888004/23bb7f83-7530-4c0e-81b2-2d02befaaba7)

# Dengue R0 model parameter
![image](https://github.com/30-na/Dengue_model/assets/78888004/c1d223e7-9138-4969-868a-e584b3623409)
![image](https://github.com/30-na/Dengue_model/assets/78888004/0fc7e724-df81-4ea8-9e43-ecefc056c71d)
![image](https://github.com/30-na/Dengue_model/assets/78888004/c0f22535-b6c1-40e3-819a-5744f9f83f86)


T = Temperature (C)  
b_v = Mosquito biting rate  
K = 20,  
N_h (Human Population Density) = 1  

# Functions

* R0_Calculation_Amber.R  
Description: Calculates R0 number using at Amber project. 

* R0_Calculation_Brazil.R  
Description: Calculates R0 number using the Brazil data.

* R0_Calculation_WorldClim.R   
Description: Calculates R0 number based on WorldClim data.

* download_WorldClim_data.R  
Description: Downloads WorldClim climate data for further analysis.

* load_CEDA_precipitation.R  
Description: Loads precipitation data from CEDA (Climate and Environmental Data Archive).

* load_CEDA_temperature.R  
Description: Loads temperature data from CEDA (Climate and Environmental Data Archive).

* load_WorldClim_data.R  
Description: Loads WorldClim climate data for analysis.  

* load_geolocalized_economic_data.R  
Description: Loads geolocalized economic data, replacing G-Econ data for countries with N/A values in 2005.

* load_global_aedes_distribution_data.R  
Description: Loads global Aedes distribution data for analysis.

* load_human_population_density_data.R  
Description: Loads human population density data for analysis.

* plot_R0_WorldClim.R  
Description: Generates a plot of R0 values based on WorldClim data.

* plot_counterR0.R  
Description: Generates a plot with contour lines for the Briere function.

* plot_rawData_WorldClim.R  
Description: Generates a plot of raw data from WorldClim.


# Refrences
[Climate predicts geographic and temporal variation in mosquito-borne disease dynamics on two continents](https://www.nature.com/articles/s41467-021-21496-7)

[Global risk model for vector-borne transmission of Zika virus reveals the role of El Niño 2015](https://www.pnas.org/doi/10.1073/pnas.1614303114)

[Geographical distribution of the association between El NiñoSouth   Oscillation   and   dengue   fever   in   the   Americas:a   continental   analysis   using   geographical   informationsystem-based techniques](https://geospatialhealth.net/index.php/gh/article/view/12/12)

[Sensitivity of large dengue epidemics in Ecuador to long-lead predictions of El Niño
](https://www.sciencedirect.com/science/article/pii/S2405880718300347)

