BASE=$HOME/Repos/Defenders/section7_database/data_prep
PYTH=$BASE/Python
DATA=$BASE/R/sec7_prep_v3
STDN="/Users/jacobmalcom/OneDrive - Defenders of Wildlife/ESA_species/name_reference"

python $PYTH/homogenize_species_names.py \
    $DATA/pre_names.tsv \
    "$STDN/EndSp_standard_names.tab" \
    $DATA/apr2016_names_corrected_v1.tsv
