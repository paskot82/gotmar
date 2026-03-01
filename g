#!/bin/bash
# box.sh <номер_ящика> <время> [current_fill]




# color
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
NC=$(tput sgr0) #  Stop color



# ─────────────── Входные данные ───────────────
box_num=$1          # номер ящика
time_input=$2       # время (ЧЧ:ММ)
current_fill=$3     # текущая загрузка (необязательный параметр)


language="np"
add_ydarov=3 # сколько ударов идет после "0" до смены ящика

for_test() {
box_num="3"
c120="212108504"
current_fill="1968"
max_fill="2736"
per_stroke="48"
cycle_box_shot="19:57"
#current_fill="9600"
#max_fill="23040"
#per_stroke="96"
#cycle_box_shot="7.75"
time_input="08:52:57"
}

#for_test





  if [ $language == "en" ];then
h_current_fill="(how many items are already in the box?)"
h_max_fill="(box capacity?)"
h_per_stroke="(how many items per stroke?)"
h_cicle_box="(cycle time per stroke)\n       or\n (time to fill one box)"
h_sosed="How many preforms are in the next box?"

elif [ $language == "ru" ];then

h_current_fill="(сколько уже в ящике?)"
h_max_fill="(вместимость ящика?)"
h_per_stroke="(сколько изделий за удар?)"
h_cicle_box="(время цикла одного удара)\n       или\n (время наполнения 1 ящика)"
h_sosed="сколько уже приформ в соседнем ящике?"

elif [ $language == "bl" ];then
h_current_fill="(колко броя вече има в кутията?)"
h_max_fill="(капацитет на кутията?)"
h_per_stroke="(колко изделия на един удар?)"
h_cicle_box="(време на цикъл за един удар)\n       или\n (време за напълване на една кутия)"
h_sosed="Колко преформи има вече в следващия кашон?"

elif [ $language == "np" ];then
h_current_fill="(box ma ahile kati chha?)"
h_max_fill="(box ko total kati ho?)"
h_per_stroke="(ek choti ma kati ota jharchha?)"
h_cicle_box="(ek stroke ko cycle time)\n       wa\n (ek box bharna lagne samay)"
 h_sosed="Arko bakasma ahile samma kati preform chha?"

fi




if [ "$2" ];then
time_input="${time_input}:00"
fi







ask() {

if [[ "$big_num" ]];then dd="($((big_num+box_num)))"; fi
if [[ "$last_big_num" ]];then ddd="(${last_big_num})"; fi
echo ${GREEN}
echo "        __________"
echo "             box N:  $box_num $dd $ddd"
#echo "            Drops: +$ydarov"
echo "              C120:  $c120"
echo "Текущая вместимось:  $current_fill"
echo "   Размер упаковки:  $max_fill"
echo "       Число гнезд:  $per_stroke"
echo "       время цикла:  $cycle_time"
echo "       время ящика:  $tsikl"
echo "_________________"
echo $NC
}













if [ -z "$box_num" ];then
clear
ask
echo "box number?"
read box_num big_num last_big_num

if [ "$big_num" ];then
big_num=$((${big_num}-${box_num}))
fi
fi




if [ -z "$c120" ];then
clear
ask
echo "c120 ?"
read c120
time_input=$(date +%H:%M:%S)

fi

if [[ "${#c120}" -ge "9" && -n $(echo $c120 | grep ^21) ]];then
mashina_14="true"

fi





if [ -z "$current_fill" ];then
clear
ask
echo "Текущая вместимось"

echo "${BLUE}${h_current_fill}${NC}"
read current_fill
	if [ -z "$time_input" ];then
		time_input=$(date +%H:%M:%S)
	fi
fi





if [[ "${mashina_14}" == "true" ]];then
echo "${h_sosed}"
#echo "сколько уже приформ в соседнем ящиек?"

read sosed
fi






if [[ -z "$current_fill" && -z "${time_input}" ]];then
clear
ask
echo "когда закончился ящик $box_num?"
read time_input
time_input="${time_input}:00"
fi



if [ -z "$max_fill" ];then
clear
ask
echo "Размер упаковки"
echo "${BLUE}${h_max_fill}${NC}"
read max_fill
fi


if [ -z "$per_stroke" ];then
clear
ask
echo "число гнезд"
echo "${BLUE}${h_per_stroke}${NC}"
read per_stroke
fi




if [ -z $cycle_box_shot ];then
clear
ask
echo "время цикла"
echo -e "${BLUE}${h_cicle_box}${NC}"
read cycle_box_shot
fi





# ─────────────── Функции ───────────────
to_hms () {
    local t=$1
    printf "%02d:%02d:%02d" $(( (t/3600) % 24 )) $(((t%3600)/60)) $((t%60))
}

if [[ "${mashina_14}" == "true" ]];then
ydarov_for_14=$max_fill
fi
ydarov=$(echo "scale=2; ${max_fill}/${per_stroke}" | bc)


decatue=$(echo $ydarov | awk -F"[.|,]" '{print $2}')




if [ $decatue -gt 0 ];then
echo "______________"
echo "${RED} WORNING!"
echo "вы ввели неправильное общее число Приформ в ящике"
echo "или"
echo "неправильное число Приформ за один удар"
echo " ${max_fill} / ${per_stroke} = $ydarov${NC}"
echo


ydarov_less=$(echo $ydarov | awk -F"[.|,]" '{print $1}')
ydarov_more=$(($ydarov_less+1))


max_fill_less=$(($ydarov_less * ${per_stroke}))
max_fill_more=$(($ydarov_more * ${per_stroke}))

octatok_less=$(($max_fill-$max_fill_less))
octatok_more=$(($max_fill_more-$max_fill))



if [ $octatok_less -lt $octatok_more ];then

color_L=${GREEN}
recomend_L="   - вероятнее всего!"

elif [ $octatok_less -gt $octatok_more ];then

color_M=${GREEN}
recomend_M="   - вероятнее всего!"

elif [ $octatok_less -eq $octatok_more ];then
echo " $max_fill_less и $max_fill_more одинаково удалены от $max_fill"


fi

echo
echo "какое число использовать?"

echo " 1) ${color_L}${max_fill_less}  (-${octatok_less}) ${recomend_L}${NC}"
echo " 2) ${YELLOW}$max_fill   - ты ввёл.${NC}"
echo " 3) ${color_M}${max_fill_more}  (+${octatok_more}) ${recomend_M}${NC}"
echo 
echo " 4) изменить 'общее количествао приформ'"
echo " 5) изменить 'число изделий за удар'"
echo " 7) начать всё заново!"
echo
echo "0) - EXIT"
read chouse
if [ "$chouse" == "1" ];then 
max_fill=${max_fill_less}

elif [ "$chouse" == "2" ];then 
max_fill=${max_fill}

elif [ "$chouse" == "3" ];then 
max_fill=${max_fill_more}


elif [ "$chouse" == "4" ];then 
echo "впишите новое \"общее количествао приформ\""
read max_fill

elif [ "$chouse" == "5" ];then 
echo "впишите новое \"число изделий за удар\""
read per_stroke

elif [ "$chouse" == "7" ];then 

exec "$0"

elif [ "$chouse" == "0" ];then 
exit 0
else
echo "неправильный выбор"
exit 1
fi
ydarov=$(echo "scale=2; ${max_fill}/${per_stroke}" | bc)

fi


find_time_cycle() {
c_A=$(echo "$cycle_box_shot" | awk -F":" '{print $1}')
c_V=$(echo "$cycle_box_shot" | awk -F":" '{print $2}')
 cycle_time_cek=$(echo "scale=3; $c_A * 60 + $c_V" | bc)
cycle_time=$(echo "scale=3; $cycle_time_cek / $ydarov" | bc)
#echo "$cycle_time"
}



find_time_box() {

box_1_cek=$(echo "scale=3; ${ydarov}*${cycle_box_shot}" | bc)
echo "box_1_cek: $box_1_cek"

if [[ "$(uname)" == "Linux" ]]; then
	echo "$(uname)"
	chiclo=$(echo "scale=2; ${box_1_cek}/60" | bc)   # разкоментируй для линукса
	chiclo=$(printf "%.2f\n" $chiclo)	
elif [ "$(uname)" == "Darwin" ] || [[ "$os_type" == "FreeBSD" ]]; then
	echo "$(uname)"
	chiclo=$(echo "scale=2; ${box_1_cek}/60" | bc | sed "s/\./,/g") # закоментируй для линукса	
	chiclo=$(printf "%.2f\n" $chiclo)
	chiclo=$(echo $chiclo | sed "s/,/\./g") # закоментируй для линукса

fi


c_A=$(echo "$chiclo" | awk -F"." '{print $1}')
c_V=$(echo "$chiclo" | awk -F"." '{print $2}')
c_V=$(echo "scale=3; $c_V*0.6" | bc | awk -F"." '{print $1}')

if [[ "${#c_V}"  -le 1 ]];then
c_V="0${c_V}"
fi
tsikl="${c_A}:${c_V}"
#test_cikkkl=$(to_hms $chiclo)
echo;
echo
#echo $cycle_time
}




if [ $(echo ${cycle_box_shot} | grep ':') ];then

tsikl="$cycle_box_shot"
find_time_cycle
else
cycle_time="$cycle_box_shot"
find_time_box
fi


info() {


echo "   time_input:  $time_input"
echo "         c120:  $c120"
echo "     c120_end:  $c120_end"
echo " current_c120:  $current_c120"
echo "first_end_sec:  $first_end_sec ($(to_hms $first_end_sec))"
echo "      end_sec:  $end_sec ($(to_hms $end_sec))"
echo "    tsikl_sec:  $tsikl_sec ($(to_hms $tsikl_sec))"
echo "      end_sec:  $end_sec  ($(to_hms $end_sec))"
echo "  current_end:  $current_end  ($(to_hms $current_end))"
echo "Preform in box:  $current_fill"
echo
echo

echo ${GREEN}
echo "            Shift: $cmena"
echo "        __________"
echo "            Drops: +$ydarov"
echo "    Total Preform:  $max_fill"
echo "Preform in 1 drop:  $per_stroke"
echo "      Time 1 drop:  $cycle_time"
echo "      Time 1  box:  $tsikl"
echo "_______"

echo $NC
}






# ─────────────── Переводы в секунды ───────────────
tsikl_sec=$((10#${tsikl%%:*} * 60 + 10#${tsikl##*:}))
end_sec=$((10#${time_input%%:*} * 3600 + 10#${time_input##*:} * 60))


echo "end_sec: $end_sec"

hhh="$(echo $time_input | awk -F":" '{print $1}')"
mmm="$(echo $time_input | awk -F":" '{print $2}')"
sss="$(echo $time_input | awk -F":" '{print $3}')"

#end_sec=$(($hhh * 3600 + $mmm * 60 + $sss))

time_now_sec=$(echo "scale=3; $hhh * 3600 + $mmm * 60 + $sss" | bc)
end_sec=$(echo "scale=3; $hhh * 3600 + $mmm * 60 + $sss + $add_ydarov * $cycle_time" | bc | awk -F"[.|,]" '{print $1}')

echo "end_sec: $end_sec"


# ─────────────── Определение режима ───────────────
if [ -n "$current_fill" ]; then
    # время указано внутри цикла, нужно досчитать конец ящика
    remain=$(( (max_fill - current_fill) / per_stroke ))   # сколько ударов осталось
    remain_time=$(echo "$remain * $cycle_time" | bc)       # сколько секунд до конца
    remain_time=${remain_time%.*}
    end_sec=$(( end_sec + remain_time ))
    # счётчик до конца ящика
	
	
if [[ "${mashina_14}" == "true" ]];then
echo "mashina_14 =trye"
	c120_end=$(( remain * per_stroke + c120 - $sosed))

else	
    c120_end=$(( c120 + remain ))
fi	
	
	
	
	
	
else
    # если current_fill не указан → end_sec это конец ящика
    c120_end=$(( c120 + (max_fill / per_stroke) ))
fi

# ─────────────── Определение смены ───────────────
shift1_start=$((6*3600 + 30*60))    # 06:30
shift1_end=$((18*3600 + 30*60))     # 18:30
shift2_start=$shift1_end            # 18:30
shift2_end=$((24*3600 + 6*3600 + 30*60)) # 06:30 next day

# пересчитаем первый конец
first_end_sec=$((end_sec - (box_num - 1) * tsikl_sec))
#echo "first_end_sec: $first_end_sec"
if [ $end_sec -ge $shift1_start ] && [ $end_sec -le $shift1_end ]; then
    current_shift_end=$shift1_end
    next_shift_start=$shift2_start
    next_shift_label="второй смены"
	cmena=1
else
    if [ $end_sec -lt $shift1_start ]; then
        first_end_sec=$((24*3600 + first_end_sec))
        end_sec=$((24*3600 + end_sec))
		

    fi
    current_shift_end=$shift2_end
    next_shift_start=$(($shift1_start + 24*3600))
    next_shift_label="первой смены следующего дня"
	cmena=2
fi

# ─────────────── Вывод списка ───────────────
i=1


current_end=$first_end_sec


if [[ "${mashina_14}" == "true" ]];then
echo
current_c120=$(( c120_end - (box_num - 1) * max_fill ))
else
current_c120=$(( c120_end - (box_num - 1) * (max_fill / per_stroke) ))
fi

info
echo "_________________________________"

echo "       - $(to_hms $((current_end - tsikl_sec)) )"



while [ $current_end -le $current_shift_end ]; do

#time_now=$(date +%H:%M)

if [[ "$current_end" -gt "$time_now_sec" ]];then echo -n ${BLUE}; fi
if [[ "$big_num" ]];then big_num=$(($big_num+1)); dop="($big_num) "; fi



if [[ "${mashina_14}" == "true" ]];then

c120_i_1=$((current_c120 + $per_stroke))
c120_i_2=$((current_c120 + ( 2 * $per_stroke) ))
    echo "Box $(printf "%2d" $i) $dop- $(to_hms $current_end) | C120: $current_c120 (+$per_stroke)..${c120_i_1: -3}  (+$((per_stroke *2 )))..${c120_i_2: -3}${NC}"
else
	echo "Box $(printf "%2d" $i) $dop- $(to_hms $current_end) | C120: $current_c120 ${NC}"
fi

    i=$((i + 1))
    current_end=$((current_end + tsikl_sec))
if [ $current_c120 ];then	

	if [[ "${mashina_14}" == "true" ]];then
		current_c120=$((current_c120 + max_fill ))
	else
		current_c120=$((current_c120 + (max_fill / per_stroke)))
	fi
	fi
done

# ─────────────── Первый ящик следующей смены ───────────────

if [ -z $last_big_num ];then
first_box_next_end=$((current_end))
echo "_________________________________"
echo "${RED}Box  1 - $(to_hms $first_box_next_end) | C120: $current_c120${NC}"
else
	echo "!"
while [ $big_num -lt $last_big_num ]; do
big_num=$(($big_num+1)); dop="($big_num) ";

echo "Box $(printf "%2d" $i) $dop- $(to_hms $current_end) | C120: $current_c120${NC}" 
i=$((i + 1)) 
current_end=$((current_end + tsikl_sec))
if [ $current_c120 ];then                        current_c120=$((current_c120 + (max_fill / per_stroke)))
fi	
done	
fi	

#info
