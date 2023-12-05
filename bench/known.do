cscript
input y x freq
1 1 10
1 2 10
2 1 10
2 2 10
end
decomph y x [fw=freq]
matrix T_H = 1,1,0
matrix T_percent = 100, 100, 0
assert mreldif(r(H),T_H) < 1e-8
assert mreldif(r(percent),T_percent) < 1e-8

clear
input y x freq
1 1 10
1 2 0
2 1 0
2 2 10
end
decomph y x [fw=freq]
matrix T_H = 1,0,1
matrix T_percent = 100, 0, 100
assert mreldif(r(H),T_H) < 1e-8
assert mreldif(r(percent),T_percent) < 1e-8