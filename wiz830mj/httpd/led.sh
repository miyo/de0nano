while :
do
	wget -S --spider "http://10.0.0.2/action?v=55"
	sleep 1
	wget -S --spider "http://10.0.0.2/action?v=aa"
	sleep 1
done

