# Import Libraries

library(sqldf)
library(dplyr)


# Q 16 Write a query in SQL to find the name of those movies where one or more actors acted in two or more movies

movie <- read.csv("q14_movie.csv")

movie_cast <- read.csv("q16_movie_cast.csv")


sqldf('select * from movie m join movie_cast mc on m.mov_id=mc.mov_id where mc.act_id in  
      (select act_id from movie_cast group by act_id having count(mov_id)>1)')



tmp <- movie_cast %>% group_by(act_id) %>% summarise(num_movies=n_distinct(mov_id)) %>% filter(num_movies>1) 

inner_join(movie,movie_cast,by='mov_id') %>% filter(act_id %in% tmp$act_id)


inner_join(movie,movie_cast,by='mov_id') %>% 
  filter(act_id %in% (movie_cast %>% group_by(act_id) %>% summarise(num_movies=n_distinct(mov_id)) %>% filter(num_movies>1) %>% select(act_id)))
