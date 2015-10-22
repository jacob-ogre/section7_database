# Wrapper script to prepare Section 7 consultation data.
# Copyright (C) 2015 Defenders of Wildlife, jmalcom@defenders.org

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

################################################################################
# Colors for later:
################################################################################
red='\x1b[0;31m'
grn='\x1b[0;32m'
ncl='\x1b[0m'

#############################################################################
# echo to give information on Excel-specific preparation
#############################################################################
function usage {
    echo -e "";
    echo -e "Prepare Section 7 data for analysis.";
    echo -e "";
    echo -e "USAGE:";
    echo -e "    ./prep_Sec7_data.sh <indir> <outbase>";
    echo -e "ARGS:";
    echo -e "    indir, path to directory of Section 7 Excel files";
    echo -e "    outfile, path to output files, one tab-delimited and one RData";
    echo -e "REQUIRES:";
    echo -e "    DataPrep_S1_Excel.py";
    echo -e "        xlrd; install with 'sudo pip install xlrd'";
    echo -e "COMMENTS:";
    echo -e "    This script calls R and Python scripts to prepare Excel files";
    echo -e "    of Section 7 data for analysis and use with a Shiny App UI.";
    echo -e "";
    exit;
}

function convertExcel {
    for f in $INDIR; do
        new1="${f%.xlsx}.tab";
        echo "python -u $PYBASE/DataPrep_S1_Excel.py $f > $new1";
        python -u $PYBASE/DataPrep_S1_Excel.py $f > $new1;
    done;
    echo -e "${grn}    Excel conversion complete.${ncl}";
}

function catGzipTabd {
    echo cat Excels/*.tab > TABs/FWS_consultations_08-14.tab;
    cat Excels/*.tab > TABs/FWS_consultations_08-14.tab;
    echo tar -czf TABs/FWS_consultations_08-14.tgz Excels/*.tab;
    tar -czf TABs/FWS_consultations_08-14.tgz Excels/*.tab;
    echo rm Excels/*.tab
    rm Excels/*.tab
    echo -e "${grn}    Tab'd files catenated, archived.${ncl}";
}

function cleanWithR_S2 {
    echo Rscript $RBASE/DataPrep_S2_dfPrep.R;
    Rscript --vanilla $RBASE/DataPrep_S2_dfPrep.R
    echo -e "${grn}    Data filtered, reduced.${ncl}";
}

function expandConclusions {
    echo python -u $PYBASE/DataPrep_S3_detExpansion.py 
    echo     $DATABASE/TABs/FWS_consults_08-14_filt_uniq.tab 
    echo     $DATABASE/TABs/FWS_consults_08-14_filt_uniq_expand.tab 
    echo     $DATABASE/BiOps_recategorize.tsv 
    echo     $DATABASE/BiOps_CH_recategorize.tsv
    python -u $PYBASE/DataPrep_S3_detExpansion.py \
        $DATABASE/TABs/FWS_consults_08-14_filt_uniq.tab \
        $DATABASE/TABs/FWS_consults_08-14_filt_uniq_expand.tab \
        $DATABASE/BiOps_recategorize.tsv \
        $DATABASE/BiOps_CH_recategorize.tsv
    echo -e "${grn}    BiOp determinations expanded.${ncl}";
}

function finalPrep {
    Rscript --vanilla $RBASE/DataPrep_S4_finalPrep.R
}

# First check if help is required:
if [ $1 == "--help" ] || [ $# -ne 2 ]; then
    usage;
fi

################################################################################
# Next set the variables
################################################################################
INDIR=$1/*.xls*  # Gets old and new Excel formats...
OUTBASE=$2
PYBASE="/Users/jacobmalcom/Defenders_JWM/Python/Sec7"
RBASE="/Users/jacobmalcom/Defenders_JWM/R/Sec7/sec7_prep_v2"
DATABASE="/Users/jacobmalcom/OneDrive/Defenders/data/ESA_consultations"

################################################################################
# Run the pipeline:
################################################################################
# convertExcel;
# catGzipTabd;
# cleanWithR_S2;
# expandConclusions;
# finalPrep;










