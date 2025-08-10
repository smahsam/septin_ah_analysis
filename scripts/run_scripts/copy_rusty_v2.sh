#!/usr/bin/env bash

mpath=$1
vfinal=$2

scp -r rusty:$1/toppar .
scp -r rusty:$1/topol.top .
scp -r rusty:$1/density_groups.ndx .
scp -r rusty:$1/step5* .
scp -r rusty:$1/step6*.tpr .
scp -r rusty:$1/step6*.gro .
scp -r rusty:$1/step6*.cpt .
scp -r rusty:$1/step7_production.mdp .

scp -r rusty:$1/*v1_$vfinal.edr .
scp -r rusty:$1/*v1_${vfinal}_redu* .
scp -r rusty:$1/step7_$vfinal.nowat.tpr .
scp -r rusty:$1/step7_$vfinal.cpt .
scp -r rusty:$1/step7_$vfinal.log .
scp -r rusty:$1/step7_$vfinal.gro .

