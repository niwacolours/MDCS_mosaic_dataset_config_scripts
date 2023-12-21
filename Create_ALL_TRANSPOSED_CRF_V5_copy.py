# SCENZ, Update November 2023
#
"""
This script builds multi-dimensional info of the individual datasets and uses that
for exporting Transposed CRF files.

Script needs to run when new File Geodatabases have been set up for 'raw' output rasters 
(i.e. after re-creation of all environments as well as after raster slices have been added)

This script can be used for the TEST build 
or the PROD build after configuring the gisenviron variable
"""
import arcpy

# import os

# CHOOSE WHICH ArcGIS Enterprise Environment to publish to: either GIS or GISTEST
gisenviron = "GIS"

arcpy.env.overwriteOutput = "True"

# The array structure in one of the following lines is used to configure which timesteps & \
# type to run for (choose one):

for ts in ["SE", "YR", "7D", "MO", "SC", "YC", "7C", "MC", "SA", "YA", "7A", "MA"]:
    # for ts in ["SC", "YC", "7C", "MC", "SA", "YA", "7A", "MA"]:
    # for ts in ["SA", "YA", "7A", "MA"]:
    # for ts in ["SC", "YC", "7C", "MC", "7D", "SA", "YA", "7A"]:
    # for ts in ["YA", "YR"]:
    print(f"Timestep {ts} in environment {gisenviron} starting")

    if gisenviron == "GISTEST":
        arcpy.env.workspace = f"C:/Temp/MRF_LERC_TEST_5/SCENZ_ALL_{ts}.gdb"
    else:
        arcpy.env.workspace = f"C:/Temp/05_PROD/SCENZ_ALL_{ts}.gdb"

    try:
        arcpy.md.BuildMultidimensionalInfo(
            f"SCENZ_ALL_{ts}",
            "Variable",
            "StdTime Time years/months/days/hours/minutes/seconds",
            "ADET 'Absorption of detrital material at 443 nm' 1/m;\
            BBP 'Particulate backscatter at 555 nm' 1/m;\
            CHL 'Chlorophyll a concentration' mg/m3;\
            EBED 'Light (Energy) at the sea bed' 'mol photons m2/day';\
            HVIS 'Black disk horizontal visibility distance' m;\
            KPAR 'Downwelling light attenuation of photosynthetically active radiation(PAR) 400-700 nm' 1/m; \
            PAR 'Photosynthetically active radiation (PAR) 400-700 nm' 1/m ;\
            POB 'Proportion OBserved' /;\
            SEC 'Vertical visibility of a black and white Secchi disk' m;SST 'Sea Surface Temperature' 'degrees C';\
            TSS 'Total Suspended Solids' g/m3",
            "NO_DELETE_MULTIDIMENSIONAL_INFO",
        )

        print(f"Multidimensional Info for {ts} built. Starting CRF Export")
    except:
        print("error..")

    if gisenviron == "GISTEST":
        try:
            arcpy.management.CopyRaster(
                f"SCENZ_ALL_{ts}",
                f"C:/Temp/MRF_LERC_TEST_5/SCENZ_ALL_{ts}_CopyRaster.crf",
                "",
                None,
                "3.4e+38",
                "NONE",
                "NONE",
                "",
                "NONE",
                "NONE",
                "CRF",
                "NONE",
                "ALL_SLICES",
                "TRANSPOSE",
            )

            print(f"Timestep {ts} done ......................")

        except AttributeError:
            print("error ..")
    else:
        try:
            arcpy.management.CopyRaster(
                f"SCENZ_ALL_{ts}",
                f"C:/Temp/05_PROD/SCENZ_ALL_{ts}_CopyRaster.crf",
                "",
                None,
                "3.4e+38",
                "NONE",
                "NONE",
                "",
                "NONE",
                "NONE",
                "CRF",
                "NONE",
                "ALL_SLICES",
                "TRANSPOSE",
            )

            print(f"Timestep {ts} done ......................")
        except AttributeError:
            print("error ..")
