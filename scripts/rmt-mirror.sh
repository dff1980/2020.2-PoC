rmt-cli sync

#Need reconfigure to use product instead repos
#repos=$(rmt-cli repos list --all)
#for REPO in SLE-Product-SLES15-SP2-{Pool,Updates} SLE-Module-Server-Applications15-SP2-{Pool,Updates} SLE-Module-Basesystem15-SP2-{Pool,Updates} SLE-Module-Containers15-SP2-{Pool,Updates}
# do
#  rmt-cli repos enable $(echo "$repos" | grep "$REPO for sle-15-x86_64" | sed "s/^|\s\+\([0-9]*\)\s\+|.*/\1/");
# done

#rmt-cli mirror 
