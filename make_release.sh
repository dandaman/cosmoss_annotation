#!/bin/bash

NAME=cosmoss.genonaut

perl -MDate::Simple -e '$d=Date::Simple->new(Date::Simple::today()); $y=$d->year(); open(F, "RELEASE"); $S=<F>; ($r) = ($S=~/release $y\.(\d+)/); open(F, ">RELEASE"); print F "cosmoss.org genonaut annotation release $y.",++$r," released on ", Date::Simple::today(),"\n";'

psql -A -t -F'	' cosmoss -c " select accession,go_id,description from (select accession, value as go_id , term_id, evidencecode, annotator_id, source, date,version_id from features where active=1 and version_id in (6,4,5) and term_id in (4,5,6) and status != 2) as GO left join (select accession,value as description from  features where active=1 and version_id in (6,4,5) and term_id = 3 and status != 2) as d using (accession) order by version_id asc, accession asc, term_id asc;" |sort -u > $NAME.annot

psql -A -t -F'	' cosmoss -c " select accession,go_id,annotator_id,evidencecode,date,source,description from (select accession, value as go_id , term_id, evidencecode, annotator_id, source, date,version_id from features where active=1 and version_id in (6,4,5) and term_id in (4,5,6) and status != 2) as GO left join (select accession,value as description from  features where active=1 and version_id in (6,4,5) and term_id = 3 and status != 2) as d using (accession) order by version_id asc, accession asc, term_id asc;"|sort -u  > $NAME.txt

psql -A -t -F'	' cosmoss -c "select 'cosmoss_PpV1.6' as db, accession as db_object_id,accession as db_object_symbol, '' as qualifier, value as go_id,case when (csid!= 0) then 'cosmoss_ref:'||csid else '' end as db_reference,evidencecode,'' as with,upper(substring(substring(name from E'\\\\S+\$'),1,1)) as aspect, (select distinct value from features where accession=F.accession and term_id = 10 and active=1 and version_id in (6,4,5) and status!=2) as db_object_name, '' db_object_synonym,'gene_product' as db_object_type, 'taxon:3218' as taxon, to_char(date,'YYYYMMDD') as date, 'cosmoss' as asigned_by, '' as annotation_extension, 'cosmoss_V1.6:'||accession as gene_product_form_id from features F join terms using (term_id) where active=1 and version_id in (6,4,5) and term_id in (4,5,6) and status != 2;"|sort -u > $NAME.gaf2
echo "!gaf-version: 2.0" >temp
cat temp $NAME.gaf2> temp2
mv temp2 $NAME.gaf2
rm temp

psql -A -F'	' cosmoss -c "select accession,features.annotator_id,coslink.csid, features.date,value, source from features left join coslink using (feature_id) where features.active=1 and version_id in (6,4,5) and term_id in (1) and features.status != 2 and ((coslink.active=1 and coslink.status !=2) or (coslink.feature_id is NULL)) group by accession,features.annotator_id,coslink.csid, features.date,value, source order by date desc;" |grep -v 'rows)'|perl -e 'while (<>) {chomp; my @a=split/\t/; if ($a[0] eq "accession") {@c=@a;next;} $l{$a[0]}{$a[2]}=\@a;} print join("\t", @c),"\n"; foreach my $p (sort keys %l) {my ($c)=keys %{$l{$p}}; my @b=@{$l{$p}{$c}}; $b[2]=join(",", keys %{$l{$p}}); print join("\t", @b),"\n";} ' > $NAME.gene_name.txt
psql -A  -F'	' cosmoss -c "select accession,features.annotator_id,coslink.csid, features.date,value, source from features left join coslink using (feature_id) where features.active=1 and version_id in (6,4,5) and term_id in (2) and features.status != 2 and ((coslink.active=1 and coslink.status !=2) or (coslink.feature_id is NULL)) and value !~ '^Phypa|all_Phypa|BA|NP' group by accession,features.annotator_id,coslink.csid, features.date,value, source order by date desc;" |grep -v 'rows)'| perl -e 'while (<>) {chomp; my @a=split/\t/; if ($a[0] eq "accession") {@c=@a;next;} $l{$a[0]}{$a[2]}=\@a;} print join("\t", @c),"\n"; foreach my $p (sort keys %l) {my ($c)=keys %{$l{$p}}; my @b=@{$l{$p}{$c}}; $b[2]=join(",", keys %{$l{$p}}); print join("\t", @b),"\n";} ' > $NAME.aliases.txt
psql -A  -F'	' cosmoss -c "select accession,features.annotator_id,coslink.csid, features.date,value, source from features left join coslink using (feature_id) where features.active=1 and version_id in (6,4,5) and term_id in (10) and features.status != 2 and ((coslink.active=1 and coslink.status !=2) or (coslink.feature_id is NULL)) group by accession,features.annotator_id,coslink.csid, features.date,value, source order by date desc;" |grep -v 'rows)'| perl -e 'while (<>) {chomp; my @a=split/\t/; if ($a[0] eq "accession") {@c=@a;next;} $l{$a[0]}{$a[2]}=\@a;} print join("\t", @c),"\n"; foreach my $p (sort keys %l) {my ($c)=keys %{$l{$p}}; my @b=@{$l{$p}{$c}}; $b[2]=join(",", keys %{$l{$p}}); print join("\t", @b),"\n";} ' > $NAME.protein_name.txt
psql -A  -F'	' cosmoss -c "select accession,features.annotator_id,coslink.csid, features.date,value, source from features left join coslink using (feature_id) where features.active=1 and version_id in (6,4,5) and term_id in (3) and features.status != 2 and ((coslink.active=1 and coslink.status !=2) or (coslink.feature_id is NULL)) group by accession,features.annotator_id,coslink.csid, features.date,value, source order by date desc;" |grep -v 'rows)'| perl -e 'while (<>) {chomp; my @a=split/\t/; if ($a[0] eq "accession") {@c=@a;next;} $l{$a[0]}{$a[2]}=\@a;} print join("\t", @c),"\n"; foreach my $p (sort keys %l) {my ($c)=keys %{$l{$p}}; my @b=@{$l{$p}{$c}}; $b[2]=join(",", keys %{$l{$p}}); print join("\t", @b),"\n";} ' > $NAME.description.txt

perl -e 'while (<>){ chomp; @a=split/\t/; $a[0]=~s/V6\.\d+/V6/; $l{$a[0]}{$a[1]}++;} print "$_\t",join(", ",sort keys %{$l{$_}}),"\n" foreach sort keys %l;' $NAME.annot > $NAME.map

wget http://www.geneontology.org/GO_slims/goslim_plant.obo
wget http://www.geneontology.org/ontology/obo_format_1_2/gene_ontology_ext.obo
map2slim goslim_plant.obo gene_ontology_ext.obo cosmoss.genonaut.gaf2 > cosmoss.genonaut.slim.gaf2

#cut -f1,3 $NAME.annot | sort -u > $NAME.descriptions.txt

