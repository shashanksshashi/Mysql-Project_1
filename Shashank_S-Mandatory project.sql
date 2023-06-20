-- 2) We want to reward the user who has been around the longest, Find the 5 oldest users.

select * from users
order by created_at
limit 5;

-- 3) To understand when to run the ad campaign, figure out the day of the week most users register on? 

select users.*,count(id) as number_of_users,dayname(created_at) as Day from users
group by day
order by number_of_users desc;



-- 4) To target inactive users in an email ad campaign, find the users who have never posted a photo.

select id,username from users 
where id not in (select  user_id from photos);


-- 5) Suppose you are running a contest to 'find out who got the most likes on a photo'. Find out who won?

with cte as(
select count(*)as Number_of_likes,likes.*  from likes
group by photo_id
order by Number_of_likes desc
limit 1
)
select u.username,cte.* from cte 
inner join photos p on cte.photo_id=p.id
inner join users u on u.id=p.user_id;


-- 6) The investors want to know 'how many times does the average user post'.

with cte as (
select count(id)as counts,user_id  
from photos group by user_id)
select avg(cte.counts) as average_posts from cte;


-- 7) A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

select t.tag_name,count(pt.tag_id) Number_of_hashtags from tags t 
inner join photo_tags pt on pt.tag_id=t.id
inner join photos p on p.id=pt.photo_id
group by t.tag_name
order by Number_of_hashtags desc
limit 5;


-- 8) To find out if there are bots, find 'users who have liked every single photo' on the site.

select username from (select user_id,count(*) as Number_of_likes from likes
                      group by user_id
					  order by Number_of_likes desc)X
inner join users u on x.user_id=u.id
where x.Number_of_likes=(select count(*) from photos);
 

-- 9) To know who the celebrities are, find users who have never commented on a photo.

select * from users where 
id not in (select user_id from comments) 
and id in (select user_id from photos);

-- 10) Now it's time to find both of them together, 
  -- find the users who have never commented on any photo or have commented on every photo
  
select username from users where 
id not in (select user_id from comments) 
and id in (select user_id from photos)

union all

select username from (select user_id,count(*) as Number_of_likes from likes group by user_id
                           order by Number_of_likes desc)X
                           inner join users u on x.user_id=u.id
						   where x.Number_of_likes=(select count(*) from photos);
 










