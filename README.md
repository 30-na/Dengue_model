# Dengue_model

--------------------------
# Dataset:

1. Global Climate Database.  
Monthly [min](https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tmin.zip), [max](https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tmax.zip), and [average](https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_tavg.zip) temperature (°C)and [precipitation](https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_2.5m_prec.zip) (mm) at various resolutions from 1970-2000 (Use 2.5 min spatial resolution data for 5 km) from [www.worldclim.org](https://www.worldclim.org/data/worldclim21.html)

2. [Global Aedes Distribution](https://www.dropbox.com/sh/bpxcmzmmpiiav8u/AAAl3CBKnBYwXb0n1s1C4-K-a?dl=0). 
Uncertainty estimates for mosquito distribution at 5 km x 5 km resolution (R datafiles and Aedes maps)
(Kraemer et al., 2015)

3. [Geolocalized Economic Data]().
Geophysically scaled dataset linking per capita gross product (GDP) at purchasing power parity (PPP) rates (recomputed to change 1 km x 1 km to match 5 km x 5 km resolution of other data)

4. [Human Population Density](https://hub.worldpop.org/project/categories?id=18)  
We will use the Unconstrained individual countries 2000-2020 UN adjusted (1 km resolution). This will need to be changed to match the 5 km x 5 km resolution of the other data sets.

5. [CHC-CMIP6](https://www.chc.ucsb.edu/data)  
The CHC-CMIP6 dataset provides global, daily, high spatial resolution (0.05°) grids of observational and projected CHIRTS temperature, CHIRPS precipitation, ERA5-derived relative humidity, vapor pressure deficit (VPD), and maximum Wet Bulb Globe Temperatures (WBGTmax) 
--------------------------
# Missing values
We replace Somalia PPP2005_40 value with the lowest Djibouti PPP2005_40 value in Geolocalized Economic Data

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
![image](https://github.com/30-na/Dengue/assets/78888004/f50ed169-30bb-4425-b74c-2a01612ce84b)

# Alternative Model

![image](https://github.com/30-na/Dengue/assets/78888004/caebb41e-da31-4ca2-9d84-3767d239381e)

# Dengue R0 model parameter

T = Temperature (C)  
b_v = Mosquito biting rate  
K = 20,  
N_h (Human Population Density) = 1  
Z_briere (Scaling factor) = 0.05  
Briere_min = 1  
Briere _max = 246   
Quad_min = 1  
Quad_max = 123  

# Refrences
[Climate predicts geographic and temporal variation in mosquito-borne disease dynamics on two continents](https://www.nature.com/articles/s41467-021-21496-7)

[Global risk model for vector-borne transmission of Zika virus reveals the role of El Niño 2015](https://www.pnas.org/doi/10.1073/pnas.1614303114)

[Geographical distribution of the association between El NiñoSouth   Oscillation   and   dengue   fever   in   the   Americas:a   continental   analysis   using   geographical   informationsystem-based techniques](https://geospatialhealth.net/index.php/gh/article/view/12/12)

[Sensitivity of large dengue epidemics in Ecuador to long-lead predictions of El Niño
](https://www.sciencedirect.com/science/article/pii/S2405880718300347)

