source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopsys_tools.sh;

git pull

rm -rfv `ls |grep -v ".*\.sv\|.*\.sh\|.*\.csv"`;

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30

do

echo "Run $i";

vcs -Mupdate generador_parametros.sv -o generador  -full64 -R +ntb_random_seed_automatic -sverilog  -kdb -lca -debug_acc+all -debug_region+cell+encrypt -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert

vcs -Mupdate testbench.sv -o salida_testbench  -full64 -R +ntb_random_seed_automatic -sverilog  -kdb -lca -debug_acc+all -debug_region+cell+encrypt -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert

done

