source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopsys_tools.sh;

rm -rfv `ls |grep -v ".*\.sv\|.*\.sh\|.*\.csv"`;

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90



do

echo "Run $i";

vcs -Mupdate generador_parametros.sv -o generador  -full64 -R +ntb_random_seed_automatic -sverilog  -kdb -lca -debug_acc+all -debug_region+cell+encrypt -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert

vcs -Mupdate testbench.sv -o salida_testbench  -full64 -R +ntb_random_seed_automatic -sverilog  -kdb -lca -debug_acc+all -debug_region+cell+encrypt -l log_test +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert -ntb_opts uvm-1.2

done

