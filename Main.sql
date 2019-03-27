CREATE DATABASE Movieliberty;

/*Creates the tables for the database*/
CREATE TABLE kategori(
	kategoriId INT NOT NULL AUTO_INCREMENT,
	kategoriNamn VARCHAR(50),

	PRIMARY KEY (kategoriId)
);

CREATE TABLE director(
	directorId INT NOT NULL AUTO_INCREMENT,
	directorNamn VARCHAR(50),
	directorAge varchar(50),
	directorCountry varchar(50),

	PRIMARY KEY (directorId)
);

CREATE TABLE actor(
	actorId INT NOT NULL AUTO_INCREMENT,
	actorNamn VARCHAR(50),
	actorAge varchar(50),
	actorCountry varchar(50),

	PRIMARY KEY (actorId)
);

CREATE TABLE movie(
	movieId INT NOT NULL AUTO_INCREMENT,
	moviename VARCHAR(50),
	movieDirectorId INT,
	movieDescription VARCHAR(50),
	movieIsbn VARCHAR(50),
	moviePris INT,
	movieRating INT,
  movieKategoriId INT,

	 PRIMARY KEY (movieId),
   FOREIGN KEY (movieKategoriId) REFERENCES kategori(kategoriId),
	 FOREIGN KEY (movieDirectorId) REFERENCES director(directorId)

 );

CREATE TABLE actorMovie (
  actorMovieId INT NOT NULL AUTO_INCREMENT,
  actorMovieAId INT,
  actorMovieMId INT,

  PRIMARY KEY (actorMovieId),
  FOREIGN KEY (actorMovieAId) REFERENCES actor(actorId),
  FOREIGN KEY (actorMovieMId) REFERENCES movie(movieId)

);

/*Create a movie index if there is two movies with the same name*/
CREATE UNIQUE INDEX index_isbn
ON movie (movieIsbn);


/*Insert data to the different tables*/
INSERT INTO kategori(kategoriNamn) VALUES('Action'), ('Horror'), ('Comedy');

INSERT INTO director (directorNamn,directorAge,directorCountry) VALUES('Hedon, Joss',54,'USA'),
                                                                       ('Kubrick, Stanley', 71, 'USA'),
                                                                       ('Wright, Edgar', 44, 'England'),
                                                                       ('Waititi, Taika', 43, 'New Zealand'),
                                                                       ('Lucas, George',74,'USA');

INSERT INTO actor (actorNamn, actorAge, actorCountry) VALUES('Hemsworth, Chris ',35, 'Australia'),
                                                             ('Nicholson, Jack',81, 'USA'),
                                                             (' Pegg,Simon ',49,'England'),
                                                             ('Jones, James  Earl', 88 , 'USA'),
                                                             ('Johansson, Scarlett',34,'USA'),
                                                             ('Blanchett, Cate',49,'Australia'),
                                                             ('Fisher, Carrie',60,'USA');

INSERT INTO movie (moviename,movieDirectorId,movieDescription,moviePris,movieKategoriId, movieIsbn, movieRating )
VALUES('The Shining',2,'A horror  movie base on a Steven King novel','120',2, '2313', 9),
('Hot Fuzz',3,'A fun police comedy','140',3, '1346',6),
       ('Star Wars',5,'Epic Space Opera','140',1, '1344',6),
       ('Dr Strangeove ',2,'Comedy about the Cold War','120',3,'1138',8),
       ('Thor: Ragnarok ',4,'A movie about the nordic god Thor','130',1,'1234',8),
       ('Avangers',1,'A superhero movie','120',1,'1153',8);

INSERT INTO actorMovie (actorMovieMId,actorMovieAId) VALUES(6,1),(5,1),(1,2),(2,3),(4,4),(3,4),(6,5),(2,6),(5,6);

/*Shows the different tables */
SELECT * from movie;
SELECT * from director;
Select * from actor;
SELECT * FROM actorMovie;
SELECT * From kategori;

/* Show what actor belongs to what movie and the other way round  */
SELECT actor.actorNamn, movie.moviename
FROM movie INNER JOIN actorMovie
ON movie.movieId = actorMovie.actorMovieMId
INNER JOIN actor
ON actorMovie.actorMovieAId= actor.actorId;


/* Shows all the Movies and with Director that made them*/
Select moviename,directorNamn from movie
  INNER JOIN director d on movie.movieDirectorId = d.directorId
  ;

/* Views all the movies that a specific actor are in */
SELECT movie.moviename, actor.actorNamn
FROM movie INNER JOIN actorMovie
ON movie.movieId = actorMovie.actorMovieMId
INNER JOIN actor
ON actorMovie.actorMovieAId= actor.actorId
WHERE actor.actorNamn= 'Blanchett, Cate';

/* Updates the Rating of a movie */
UPDATE movie
SET movieRating =1
WHERE movieId =1;

/*Updates the price of a movie*/
UPDATE movie
SET moviePris = 150
WHERE movieid = 2;

/* Drops all the tables */
DROP TABLE movie;
DROP TABLE actorMovie;
DROP TABLE director;
DROP TABLE actor;
DROP TABLE kategori;

/*Delete querys*/
DELETE FROM actorMovie WHERE actorMovieAId= 1;
DELETE from movie WHERE movieIsbn IS NULL;
DELETE from movie WHERE movieId =2;
DELETE FROM movie WHERE movieId = 5;
DELETE FROM  director WHERE directorId = 9 ;



/* A view of the average rating of a category  */
CREATE view katagoriRating AS
SELECT AVG(movieRating), kategoriNamn
FROM movie
inner join kategori k on movie.movieKategoriId = k.kategoriId
group by kategoriNamn;

SELECT * FROM katagoriRating;

/* Creates a view of all the movies in an alphabetical order */
CREATE view alfaMovie AS
SELECT * from movie
order by moviename;

/*Creates a view that shows the highest rated movie */
CREATE view ratingList AS
SELECT movieRating,moviename
FROM movie
ORDER BY movieRating DESC;

/* Drops all the views*/
DROP VIEW katagoriRating;
DROP VIEW ratingList;
DROP VIEW alfaMovie;

/* Creates a procedure that views all the actors over a specific age that is typed in */
DELIMITER //
CREATE PROCEDURE GetAllActorsOver(IN inActorAge INTEGER)
   BEGIN
  SELECT * FROM actor
WHERE actorAge >= inActorAge;
   END //

/* Runs the procedure*/
call GetAllActorsOver(61);

/* Creates a stored procedure that shows the total of how many movies a specific director has directed */
DELIMITER //
CREATE PROCEDURE CountDirectormovies(
 IN indirector VARCHAR(50),
 OUT total INT)
BEGIN
 SELECT count(*)
 INTO total
 FROM director
 INNER JOIN movie
 ON director.directorId = movie.movieDirectorId
WHERE indirector = directorNamn;
END//

/* Calls the procedure */
call CountDirectormovies('Hedon, Joss',@total);
SELECT @total;

/*Delete a procedure */
drop procedure CountDirectormovies;







