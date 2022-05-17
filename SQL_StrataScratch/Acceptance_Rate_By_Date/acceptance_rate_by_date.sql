select t1.date, count(t2.user_id_receiver) / count(t1.user_id_sender)::FLOAT as acceptance_rate  from 
(select date, user_id_sender, user_id_receiver
from fb_friend_requests
where action = 'sent') t1
left join
(select date, user_id_sender, user_id_receiver
from fb_friend_requests
where action = 'accepted') t2
on
t1.user_id_sender = t2.user_id_sender and 
t1.user_id_receiver = t2.user_id_receiver
group by t1.date
order by t1.date
