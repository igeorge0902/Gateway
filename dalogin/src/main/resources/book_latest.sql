CREATE DATABASE  IF NOT EXISTS `book` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `book`;
-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: localhost    Database: book
-- ------------------------------------------------------
-- Server version	5.7.12-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Fetches`
--

DROP TABLE IF EXISTS `Fetches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Fetches` (
  `fetchesId` int(11) NOT NULL AUTO_INCREMENT,
  `urlToFetch` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL COMMENT 'To be filled by an hourly job on da server',
  `description` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL COMMENT 'To be filled by an hourly job on da server',
  `topic` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `isSubscrible` tinyint(1) DEFAULT NULL,
  `TIME_` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Use it wisely',
  PRIMARY KEY (`fetchesId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fetches`
--

LOCK TABLES `Fetches` WRITE;
/*!40000 ALTER TABLE `Fetches` DISABLE KEYS */;
INSERT INTO `Fetches` VALUES (1,'https://editorial.rottentomatoes.com/article/rank-goldie-hawns-10-best-movies/','Rank Goldie Hawn\'s 10 Best Movies','When Goldie Hawn returns to theaters in this weekend’s Snatched alongside Amy Schumer, it’ll mark her first film release in 15 years — an unaccountably lengthy layoff, and one we’re happy to see come to an end. To demonstrate our affection for the ...','acting',0,'2017-05-16 15:54:28'),(2,'https://editorial.rottentomatoes.com/article/rank-kurt-russells-10-best-movies/','Rank Kurt Russell\'s 10 Best Movies','When he strolls on the screen this weekend as Ego the Living Planet in Guardians of the Galaxy Vol. 2, Kurt Russell will be bringing one of Marvel’s wackiest characters to life in the MCU — and adding another big hit to a filmography that already ...','acting',1,'2017-05-16 15:54:28');
/*!40000 ALTER TABLE `Fetches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Movie`
--

DROP TABLE IF EXISTS `Movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Movie` (
  `movieId` int(11) NOT NULL AUTO_INCREMENT,
  `detail` mediumtext COLLATE utf8_hungarian_ci,
  `name` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `thumbnail_picture` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `large_picture` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `iMDB_url` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `category` varchar(45) COLLATE utf8_hungarian_ci DEFAULT NULL,
  PRIMARY KEY (`movieId`),
  UNIQUE KEY `movieId_UNIQUE` (`movieId`)
) ENGINE=InnoDB AUTO_INCREMENT=1107 DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Movie`
--

LOCK TABLES `Movie` WRITE;
/*!40000 ALTER TABLE `Movie` DISABLE KEYS */;
INSERT INTO `Movie` VALUES (1002,'A fisherman, a smuggler, and a syndicate of businessmen match wits over the possession of a priceless diamond.','Blood Diamond','/images/movies/blood-diamond.jpg','/images/movies/blood-diamond.jpg','http://www.imdb.com/title/tt0450259','Drama'),(1003,'A private detective hired to expose an adulterer finds himself caught up in a web of deceit, corruption and murder.','Chinatown',NULL,'/images/movies/chinatown.jpg','http://www.imdb.com/title/tt0071315','Crime'),(1004,'Angie Rossini is an innocent (Italian Catholic) Macy\'s salesgirl, who discovers she\'s pregnant from a fling with Rocky, a musician. Angie finds Rocky (who doesn\'t remember her at first) to tell him she\'s pregnant and needs a doctor for an abortion.','Love with the Proper Stranger',NULL,'/images/movies/love-with-the-proper-stranger.jpg','http://www.imdb.com/title/tt0057263',NULL),(1005,'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.','Interstellar',NULL,'/images/movies/interstellar.jpg','http://www.imdb.com/title/tt0816692',NULL),(1006,'Two boys growing up in a violent neighborhood of Rio de Janeiro take different paths: one becomes a photographer, the other a drug dealer.','City of God','NULL','/images/movies/city-of-god.jpg','http://www.imdb.com/title/tt0317248',NULL),(1007,'A silent movie star meets a young dancer, but the arrival of talking pictures sends their careers in opposite directions.','The Artist','NULL','/images/movies/TheArtistMovie.jpg','http://www.imdb.com/title/tt1655442',NULL),(1008,'Set in Depression-era Franklin County, Virginia, a trio of bootlegging brothers are threatened by a new special deputy and other authorities angling for a cut of their profits.','Lawless','NULL','/images/movies/thelawless.jpg','http://www.imdb.com/title/tt1212450',NULL),(1009,'With the help of a German bounty hunter, a freed slave sets out to rescue his wife from a brutal Mississippi plantation owner.','Django Unchained','NULL','/images/movies/django.jpg','http://www.imdb.com/title/tt1853728',NULL),(1010,'Bond\'s loyalty to M is tested when her past comes back to haunt her. Whilst MI6 comes under attack, 007 must track down and destroy the threat, no matter how personal the cost.','Skyfall','NULL','/images/movies/skyfall.jpg','http://www.imdb.com/title/tt1074638','Action'),(1011,'A private detective hired to expose an adulterer finds himself caught up in a web of deceit, corruption and murder.','Chinatown','NULL','/images/movies/chinatown.jpg','http://www.imdb.com/title/tt0071315',NULL),(1012,'A criminal pleads insanity after getting into trouble again and once in the mental institution rebels against the oppressive nurse and rallies up the scared patients.','One Flew Over the Cuckoo\'s Nest','NULL','/images/movies/one-flew-over-the-cuckoos-nest.jpg','http://www.imdb.com/title/tt0073486',NULL),(1013,'An insane general triggers a path to nuclear holocaust that a war room full of politicians and generals frantically try to stop.','Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb','NULL','/images/movies/dr-strangelove.jpg','http://www.imdb.com/title/tt0057012',NULL),(1014,'A retired legal counselor writes a novel hoping to find closure for one of his past unresolved homicide cases and for his unreciprocated love with his superior - both of which still haunt him decades later.','The Secret in Their Eyes','NULL','/images/movies/el_secreto.jpg','http://www.imdb.com/title/tt1305806',NULL),(1015,'The boss of a major crime syndicate orders his lieutenant to bring a rogue gang of drug traffickers in line, a job that gets passed on to his long-suffering subordinate.','Emésztő harag','NULL','/images/movies/Outrage-Beyond.jpg','http://www.imdb.com/title/tt1462667',NULL),(1016,'After being kidnapped and imprisoned for 15 years, Oh Dae-Su is released, only to find that he must find his captor in 5 days.','Oldboy','NULL','/images/movies/oldboy.jpg','http://www.imdb.com/title/tt0364569',NULL),(1017,'A U.S Marshal investigates the disappearance of a murderess who escaped from a hospital for the criminally insane.','Shutter Island','NULL','/images/movies/shutter-island.jpg','http://www.imdb.com/title/tt1130884',NULL),(1018,'An exceptionally adept Florida lawyer is offered a job to work in New York City for a high-end law firm with a high-end boss - the biggest opportunity of his career to date.','The Devil\'s Advocate','NULL','/images/movies/the-devils-advocate.jpg','http://www.imdb.com/title/tt0118971','Drama'),(1019,'A ghostwriter hired to complete the memoirs of a former British prime minister uncovers secrets that put his own life in jeopardy.','The Ghost Writer','NULL','/images/movies/Ghostwriter.jpg','http://www.imdb.com/title/tt1139328',NULL),(1020,'A look at four seasons in the lives of a happily married couple and their relationships with their family and friends.','Another Year','NULL','/images/movies/another_year.jpg','http://www.imdb.com/title/tt1431181',NULL),(1021,'A Phoenix secretary steals $40,000 from her employer\'s client, goes on the run and checks into a remote motel run by a young man under the domination of his mother.','Psycho','NULL','/images/movies/psycho.jpg','http://www.imdb.com/title/tt0054215',NULL),(1022,'Following the death of a publishing tycoon, news reporters scramble to discover the meaning of his final utterance.','Citizen Kane','NULL','/images/movies/Citizen-Kane.jpg','http://www.imdb.com/title/tt0033467',NULL),(1023,'French filmmaker Rene Clement presents Alan Delon as a petty criminal on the run from the underground. On the Rivera, he seeks refuge in a flophouse whose soup line is served by Jane Fonda ... See full summary »','Joy House','NULL','/images/movies/joy-house.jpg','http://www.imdb.com/title/tt0058123',NULL),(1024,'Inspired by the modern classic, Wings of Desire, City involves an angel (Cage) who is spotted by a doctor in an operating room. Franz plays Cage\'s buddy who somehow knows a lot about angels.','Angyalok városa','NULL','/images/movies/city_of_angels.jpg','http://www.imdb.com/title/tt0120632',NULL),(1025,'A spoiled heiress, running away from her family, is helped by a man who is actually a reporter in need of a story.','It Happened One Night','NULL','/images/movies/It-Happened-One-Night.jpg','http://www.imdb.com/title/tt0025316',NULL),(1026,'Angie Rossini is an innocent (Italian Catholic) Macy\'s salesgirl, who discovers she\'s pregnant from a fling with Rocky, a musician. Angie finds Rocky (who doesn\'t remember her at first) to ... See full summary »','Love with the Proper Stranger','NULL','/images/movies/love-with-the-proper-stranger.jpg','http://www.imdb.com/title/tt0057263',NULL),(1027,'After a stint in a mental institution, former teacher Pat Solitano moves back in with his parents and tries to reconcile with his ex-wife. Things get more challenging when Pat meets Tiffany, a mysterious girl with problems of her own.','Silver Linings Playbook','NULL','/images/movies/silver-linings-playbook.jpg','http://www.imdb.com/title/tt1045658',NULL),(1028,'After he becomes a quadriplegic from a paragliding accident, an aristocrat hires a young man from the projects to be his caregiver.','The Intouchables','NULL','/images/movies/intouchables.jpg','http://www.imdb.com/title/tt1675434',NULL),(1029,'After India\'s father dies, her Uncle Charlie, who she never knew existed, comes to live with her and her unstable mother. She comes to suspect this mysterious, charming man has ulterior motives and becomes increasingly infatuated with him.','Stoker','NULL','/images/movies/stoker.jpg','http://www.imdb.com/title/tt1682180',NULL),(1030,'In Hamburg, German-Greek chef Zinos unknowingly disturbs the peace in his locals-only restaurant by hiring a more talented chef.','Soul Kitchen','NULL','/images/movies/Soul-Kitchen.jpg','http://www.imdb.com/title/tt1244668',NULL),(1031,'24 hours in the lives of three young men in the French suburbs the day after a violent riot.','La Haine','NULL','/images/movies/le-haine.jpg','http://www.imdb.com/title/tt0113247','Drama'),(1032,'Renton, deeply immersed in the Edinburgh drug scene, tries to clean up and get out, despite the allure of the drugs and influence of friends.','Trainspotting','NULL','/images/movies/trainspotting.jpg','http://www.imdb.com/title/tt0117951',NULL),(1033,'In 1970s America, a detective works to bring down the drug empire of Frank Lucas, a heroin kingpin from Manhattan, who is smuggling the drug into the country from the Far East.','American Gangster','NULL','/images/movies/American_Gangster.jpg','http://www.imdb.com/title/tt0765429','Drama'),(1034,'An industrial worker who hasn\'t slept in a year begins to doubt his own sanity.','The Machinist','NULL','/images/movies/the-machinist.jpg','http://www.imdb.com/title/tt0361862',NULL),(1035,'Tragedy strikes a married couple on vacation in the Moroccan desert, touching off an interlocking story involving four different families.','Bábel','NULL','/images/movies/babel.jpg','http://www.imdb.com/title/tt0449467',NULL),(1036,'An east European girl goes to America with her young son, expecting it to be like a Hollywood film.','Táncos a sötétben','NULL','/images/movies/dancer-in-the-dark.jpg','http://www.imdb.com/title/tt0168629',NULL),(1037,'Based on the true story of Jordan Belfort, from his rise to a wealthy stock-broker living the high life to his fall involving crime, corruption and the federal government.','The Wolf of Wall Street','NULL','/images/movies/the-wolf-of-wall-street.jpg','http://www.imdb.com/title/tt0993846',NULL),(1038,'In the antebellum United States, Solomon Northup, a free black man from upstate New York, is abducted and sold into slavery.','12 Years a Slave','NULL','/images/movies/12years.jpg','http://www.imdb.com/title/tt2024544',NULL),(1039,'A con man, Irving Rosenfeld, along with his seductive partner Sydney Prosser, is forced to work for a wild FBI agent, Richie DiMaso, who pushes them into a world of Jersey powerbrokers and mafia.','American Hustle','NULL','/images/movies/american-hustle.jpg','http://www.imdb.com/title/tt1800241','Crime'),(1040,'A lonely writer develops an unlikely relationship with his newly purchased operating system that\'s designed to meet his every need.','Her','NULL','/images/movies/her.jpg','http://www.imdb.com/title/tt1798709',NULL),(1041,'A Russian teenager living in London who dies during childbirth leaves clues to a midwife in her journal that could tie her child to a rape involving a violent Russian mob family.','Eastern Promises','NULL','/images/movies/eastern-promises.png','http://www.imdb.com/title/tt0765443',NULL),(1042,'A jury holdout attempts to prevent a miscarriage of justice by forcing his colleagues to reconsider the evidence.','12 Angry Men','NULL','/images/movies/12-angry-men.jpg','http://www.imdb.com/title/tt0050083','Drama'),(1043,'A Mumbai teen reflects on his upbringing in the slums when he is accused of cheating on the Indian Version of Who Wants to be a Millionaire?\"\"','Slumdog Millionaire','NULL','/images/movies/slumdog-millionaire.jpg','http://www.imdb.com/title/tt1010048',NULL),(1044,'An undercover cop and a mole in the police attempt to identify each other while infiltrating an Irish gang in South Boston.','The Departed','NULL','/images/movies/the-departed.jpg','http://www.imdb.com/title/tt0407887',NULL),(1045,'Los Angeles citizens with vastly separate lives collide in interweaving stories of race, loss and redemption.','Ütközések','NULL','/images/movies/Crash.jpg','http://www.imdb.com/title/tt0375679',NULL),(1046,'After John Nash, a brilliant but asocial mathematician, accepts secret work in cryptography, his life takes a turn for the nightmarish.','A Beautiful Mind','NULL','/images/movies/a-beautiful-mind.jpg','http://www.imdb.com/title/tt0268978',NULL),(1047,'A determined woman works with a hardened boxing trainer to become a professional.','Million Dollar Baby','NULL','/images/movies/million-dollar-baby.jpg','http://www.imdb.com/title/tt0405159',NULL),(1048,'A sexually frustrated suburban father has a mid-life crisis after becoming infatuated with his daughter\'s best friend.','American Beauty','NULL','/images/movies/american-beauty.jpg','http://www.imdb.com/title/tt0169547',NULL),(1049,'When a Roman general is betrayed and his family murdered by an emperor\'s corrupt son, he comes to Rome as a gladiator to seek revenge.','Gladiator','NULL','/images/movies/gladiator.jpg','http://www.imdb.com/title/tt0172495',NULL),(1050,'In Poland during World War II, Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.','Schindler\'s List','NULL','/images/movies/schindlers_list.jpg','http://www.imdb.com/title/tt0108052',NULL),(1051,'Forrest Gump, while not intelligent, has accidentally been present at many historic moments, but his true love, Jenny Curran, eludes him.','Forrest Gump','NULL','/images/movies/forrest-gump.jpg','http://www.imdb.com/title/tt0109830',NULL),(1052,'When his secret bride is executed for assaulting an English soldier who tried to rape her, William Wallace begins a revolt against King Edward I of England.','Braveheart','NULL','/images/movies/braveheart.jpg','http://www.imdb.com/title/tt0112573',NULL),(1053,'At the close of WWII, a young nurse tends to a badly-burned plane crash victim. His past is shown in flashbacks, revealing an involvement in a fateful love affair.','The English Patient','NULL','/images/movies/english-patient.jpg','http://www.imdb.com/title/tt0116209',NULL),(1054,'A young F.B.I. cadet must confide in an incarcerated and manipulative killer to receive his help on catching another serial killer who skins his victims.','The Silence of the Lambs','NULL','/images/movies/silence-of-the-lambs.jpg','http://www.imdb.com/title/tt0102926',NULL),(1055,'An old Jewish woman and her African-American chauffeur in the American South have a relationship that grows and improves over the years.','Driving Miss Daisy','NULL','/images/movies/driving-miss-daisy.jpg','http://www.imdb.com/title/tt0097239',NULL),(1056,'The story of the final Emperor of China.','Az utolsó császár','NULL','/images/movies/The-Last-Emperor.jpg','http://www.imdb.com/title/tt0093389',NULL),(1057,'A pair of NYC cops in the Narcotics Bureau stumble onto a drug smuggling job with a French connection.','The French Connection','NULL','/images/movies/the-french-connection.jpg','http://www.imdb.com/title/tt0067116','Crime'),(1058,'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.','The Godfather','NULL','/images/movies/the-godfather.jpg','http://www.imdb.com/title/tt0068646',NULL),(1059,'The story of TE Lawrence, the English officer who successfully united and lead the diverse, often warring, Arab tribes during World War 1 in order to fight the Turks.','Lawrence of Arabia','NULL','/images/movies/Lawrence-of-Arabia.jpg','http://www.imdb.com/title/tt0056172',NULL),(1060,'In Casablanca, Morocco during the early days of World War II, an American expatriate meets a former lover, with unforeseen complications.','Casablanca','NULL','/images/movies/casablanca.jpg','http://www.imdb.com/title/tt0034583',NULL),(1061,'A manipulative Southern belle carries on a turbulent affair with a blockade runner during the American Civil War.','Gone with the Wind','NULL','/images/movies/gone-with-the-wind.jpg','http://www.imdb.com/title/tt0031381',NULL),(1062,'A Victorian Englishman bets that with the new steamships and railways he can do what the title says.','Around the World in Eighty Days','NULL','/images/movies/around-the-world-in-80-days.jpg','http://www.imdb.com/title/tt0048960',NULL),(1063,'After settling his differences with a Japanese PoW camp commander, a British colonel co-operates to oversee his men\'s construction of a railway bridge for their captors - while oblivious to a plan by the Allies to destroy it.','The Bridge on the River Kwai','NULL','/images/movies/bridge-over-the-river-kwai.jpg','http://www.imdb.com/title/tt0050212',NULL),(1064,'Two youngsters from rival New York City gangs fall in love, but tensions between their respective friends build toward tragedy.','West Side Story','NULL','/images/movies/West-Side-Story.jpg','http://www.imdb.com/title/tt0055614',NULL),(1065,'A misogynistic and snobbish phonetics professor agrees to a wager that he can take a flower girl and make her presentable in high society.','My Fair Lady','NULL','/images/movies/my_fair_lady.jpg','http://www.imdb.com/title/tt0058385',NULL),(1066,'Ted Kramer\'s wife leaves her husband, allowing for a lost bond to be rediscovered between Ted and his son, Billy. But a heated custody battle ensues over the divorced couple\'s son, deepening the wounds left by the separation.','Kramer vs. Kramer','NULL','/images/movies/Kramer-vs-Kramer.jpg','http://www.imdb.com/title/tt0079417',NULL),(1067,'A young recruit in Vietnam faces a moral crisis when confronted with the horrors of war and the duality of man.','Platoon','NULL','/images/movies/platoon.jpg','http://www.imdb.com/title/tt0091763',NULL),(1068,'Lt. John Dunbar, exiled to a remote western Civil War outpost, befriends wolves and Indians, making him an intolerable aberration in the military.','Dances with Wolves','NULL','/images/movies/Dances_with_Wolves.jpg','http://www.imdb.com/title/tt0099348',NULL),(1069,'The early life and career of Vito Corleone in 1920s New York is portrayed while his son, Michael, expands and tightens his grip on his crime syndicate stretching from Lake Tahoe, Nevada to pre-revolution 1958 Cuba.','The Godfather: Part II','NULL','/images/movies/the-godfather-2.jpg','http://www.imdb.com/title/tt0071562',NULL),(1070,'Two counterculture bikers travel from Los Angeles to New Orleans in search of America.','Easy Rider','NULL','/images/movies/easyriders.jpg','http://www.imdb.com/title/tt0064276',NULL),(1071,'Two Navy men are ordered to bring a young offender to prison but decide to show him one last good time along the way.','The Last Detail','NULL','/images/movies/last-detail.jpg','http://www.imdb.com/title/tt0070290','Drama'),(1072,'Emma left Russia to live with her husband in Italy. Now a member of a powerful industrial family, she is the respected mother of three, but feels unfulfilled. One day, Antonio, a talented chef and her son\'s friend, makes her senses kindle.','Szerelmes lettem','NULL','/images/movies/Io-sono-l-amore.jpg','http://www.imdb.com/title/tt1226236',NULL),(1073,'In Nazi-occupied France during World War II, a plan to assassinate Nazi leaders by a group of Jewish U.S. soldiers coincides with a theatre owner\'s vengeful plans for the same.','Inglourious Basterds','NULL','/images/movies/inglourious-basterds.jpg','http://www.imdb.com/title/tt0361748',NULL),(1074,'Unscrupulous boxing promoters, violent bookmakers, a Russian gangster, incompetent amateur robbers, and supposedly Jewish jewelers fight to track down a priceless stolen diamond.','Snatch.','NULL','/images/movies/snatch.jpg','http://www.imdb.com/title/tt0208092',NULL),(1075,'An ingenue insinuates herself in to the company of an established but aging stage actress and her circle of theater friends.','All About Eve','NULL','/images/movies/all-about-eve.jpg','http://www.imdb.com/title/tt0042192',NULL),(1076,'The adventures of Gustave H, a legendary concierge at a famous hotel from the fictional Republic of Zubrowka between the first and second World Wars, and Zero Moustafa, the lobby boy who becomes his most trusted friend.','The Grand Budapest Hotel','NULL','/images/movies/The-Grand-Budapest.png','http://www.imdb.com/title/tt2278388',NULL),(1077,'In a social context deteriorated by a countrywide economic crisis, the life of several people will be turned upside down after they meet Cecile, a character who symbolizes desire.','Q - Érzékek birodalma','NULL','/images/movies/Q.jpg','http://www.imdb.com/title/tt1879030',NULL),(1078,'A neo-nazi sentenced to community service at a church clashes with the blindly devotional priest.','Adam\'s Apples','NULL','/images/movies/adams-apple.jpg','http://www.imdb.com/title/tt0418455',NULL),(1079,'The rich man Domenico and Filumena, a penniless prostitute, share great part of their lives in the immediate post WWII Italy.','Marriage Italian Style','NULL','/images/movies/marriage-italian-style.jpg','http://www.imdb.com/title/tt0058335',NULL),(1080,'An epic portrait of late Sixties America, as seen through the portrayal of two of its children: anthropology student Daria (who\'s helping a property developer build a village in the Los ... See full summary »','Zabriskie Point','NULL','/images/movies/Zabriskie-Point.jpg','http://www.imdb.com/title/tt0066601',NULL),(1081,'Comic caper movie about a plan to steal a gold shipment from the streets of Turin by creating a traffic jam.','The Italian Job','NULL','/images/movies/the-italian-job.jpg','http://www.imdb.com/title/tt0064505',NULL),(1082,'A young, ambitious mobster plans an elaborate diamond heist while seducing the daughter of a ruthless mob patriarch as a determined police commissioner closes in on all of them.','The Sicilian Clan','NULL','/images/movies/the-sicilian-clan.jpg','http://www.imdb.com/title/tt0064169',NULL),(1083,'Two neighbors, a persecuted journalist and a resigned housewife, meet during Hitler\'s visit in Italy in 1938.','A Special Day','NULL','/images/movies/a-special-day.jpg','http://www.imdb.com/title/tt0076085',NULL),(1084,'An Italian woman conducts a desperate search for her husband, a soldier considered missing in action in Russia - like fifty thousand others during WWII.','Napraforgó','NULL','/images/movies/sunflower.jpg','http://www.imdb.com/title/tt0065782',NULL),(1085,'A disillusioned college graduate finds himself torn between his older lover and her daughter.','The Graduate','NULL','/images/movies/the_graduate.jpg','http://www.imdb.com/title/tt0061722',NULL),(1086,'A mysterious Hollywood stuntman and mechanic moonlights as a getaway driver and finds himself trouble when he helps out his neighbor.','Drive','NULL','/images/movies/drive.jpg','http://www.imdb.com/title/tt0780504',NULL),(1087,'Mick Haller is a defense lawyer who works out of his Lincoln. When a wealthy Realtor is accused of assaulting a prostitute, Haller is asked to defend him. The man claims that the woman is ... See full summary »','The Lincoln Lawyer','NULL','/images/movies/lincoln-lawyer.jpg','http://www.imdb.com/title/tt1189340',NULL),(1088,'As the extremely withdrawn Don Johnston is dumped by his latest woman, he receives an anonymous letter from a former lover informing him that he has a son who may be looking for him. A freelance sleuth neighbor moves Don to embark on a cross-country search for his old flames in search of answers.','Broken Flowers','NULL','/images/movies/broken-flowers.jpg','http://www.imdb.com/title/tt0412019',NULL),(1089,'In 1945, in the World War II in Germany, the tough Sergeant Don \'Wardaddy\' Collier commands a tank and survives to a German attack with his veteran crew composed of Boyd \'Bible\' Swan, Trini... See full summary »','Fury','NULL','/images/movies/fury.jpg','http://www.imdb.com/title/tt2713180',NULL),(1090,'A young woman\'s world unravels when a drug prescribed by her psychiatrist has unexpected side effects.','Side Effects','NULL','/images/movies/side-effects.jpg','http://www.imdb.com/title/tt2053463',NULL),(1091,'A trip to Lisbon helps a nerdy guy who is quickly approaching 30 finally get his mojo back.','VAN valami furcsa és megmagyarázhatatlan','NULL','/images/movies/van-valami.jpg','http://www.imdb.com/title/tt3496334',NULL),(1092,'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.','Interstellar','NULL','/images/movies/interstellar.jpg','http://www.imdb.com/title/tt0816692',NULL),(1093,'An American adventurer investigates the past of mysterious tycoon Arkadin...placing himself in grave danger.','Confidential Report','NULL','/images/movies/Confidential-report.jpg','http://www.imdb.com/title/tt0048393',NULL),(1094,'A vengeful fairy is driven to curse an infant princess, only to discover that the child may be the one person who can restore peace to their troubled land.','Maleficent','NULL','/images/movies/maleficent.jpg','http://www.imdb.com/title/tt1587310',NULL),(1095,'Violence and mayhem ensue after a hunter stumbles upon a drug deal gone wrong and more than two million dollars in cash near the Rio Grande.','No Country for Old Men','NULL','/images/movies/no-country-for-old-men.jpg','http://www.imdb.com/title/tt0477348',NULL),(1096,'A shy young heiress marries a charming gentleman, and soon begins to suspect he is planning to murder her.','Suspicion','NULL','/images/movies/suspicion.jpg','http://www.imdb.com/title/tt0034248',NULL),(1097,'Katniss Everdeen is in District 13 after she shatters the games forever. Under the leadership of President Coin and the advice of her trusted friends, Katniss spreads her wings as she fights to save Peeta and a nation moved by her courage.','The Hunger Games: Mockingjay - Part 1','NULL','/images/movies/the-hunger-games-mockingjay-part-1.jpg','http://www.imdb.com/title/tt1951265',NULL),(1098,'A loser of a crook and his wife strike it rich when a botched bank job\'s cover business becomes a spectacular success.','Small Time Crooks','NULL','/images/movies/small-time-crooks.jpg','http://www.imdb.com/title/tt0196216',NULL),(1099,'When a shy groom practices his wedding vows in the inadvertent presence of a deceased young woman, she rises from the grave assuming he has married her.','Corpse Bride','NULL','/images/movies/corpse-bride.jpg','http://www.imdb.com/title/tt0121164',NULL),(1100,'A medical engineer and an astronaut work together to survive after an accident leaves them adrift in space.','Gravity','NULL','/images/movies/gravity.jpg','http://www.imdb.com/title/tt1454468',NULL),(1101,'Set in 1930s Paris, an orphan who lives in the walls of a train station is wrapped up in a mystery involving his late father and an automaton.','Hugo','NULL','/images/movies/hugo_clock.jpg','http://www.imdb.com/title/tt0970179',NULL),(1102,'A scheming widow and her manipulative ex-lover make a bet regarding the corruption of a recently married woman.','Dangerous Liaisons','NULL','/images/movies/dangerous-liaisons.jpg','http://www.imdb.com/title/tt0094947',NULL),(1103,'An ex-Marine turned teacher struggles to connect with her students in an inner city school.','Dangerous Minds','NULL','/images/movies/Dangerous_Minds.jpg','http://www.imdb.com/title/tt0112792',NULL),(1104,'A mentally handicapped man fights for custody of his 7-year-old daughter, and in the process teaches his cold hearted lawyer the value of love and family.','I Am Sam','NULL','/images/movies/i_am_sam.jpg','http://www.imdb.com/title/tt0277027',NULL),(1105,'A tale of nineteenth-century New York high society in which a young lawyer falls in love with a woman separated from her husband, while he is engaged to the woman\'s cousin.','The Age of Innocence','NULL','/images/movies/the-age-of-innocence.jpg','http://www.imdb.com/title/tt0106226',NULL),(1106,'A lawyer becomes targeted by a corrupt politician and his N.S.A. goons when he accidentally receives key evidence to a politically motivated crime.','Enemy of the State','','/images/movies/enemy_of_the_state.jpg','https://www.imdb.com/title/tt0120660','Action');
/*!40000 ALTER TABLE `Movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Purchase`
--

DROP TABLE IF EXISTS `Purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Purchase` (
  `purchaseId` int(20) NOT NULL AUTO_INCREMENT,
  `uuid` char(255) COLLATE utf8_hungarian_ci NOT NULL,
  `TIME_` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `orderId` char(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  PRIMARY KEY (`purchaseId`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Purchase`
--

LOCK TABLES `Purchase` WRITE;
/*!40000 ALTER TABLE `Purchase` DISABLE KEYS */;
INSERT INTO `Purchase` VALUES (77,'97c6fd76-ed90-11e9-871a-874ce8a992e2','2019-12-13 15:05:07','1576249507142'),(78,'97c6fd76-ed90-11e9-871a-874ce8a992e2','2019-12-13 15:10:00','1576249800355'),(82,'97c6fd76-ed90-11e9-871a-874ce8a992e2','2020-04-22 23:17:55','1587597475799'),(101,'65f63602-6ddf-11e5-8441-71caa0c5f788','2020-04-30 00:39:51','1588207191530'),(102,'65f63602-6ddf-11e5-8441-71caa0c5f788','2020-04-30 00:39:51','1588207191530'),(103,'65f63602-6ddf-11e5-8441-71caa0c5f788','2020-04-30 00:39:51','1588207191530'),(104,'97c6fd76-ed90-11e9-871a-874ce8a992e2','2020-05-03 21:46:03','1588542363616');
/*!40000 ALTER TABLE `Purchase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Screen`
--

DROP TABLE IF EXISTS `Screen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Screen` (
  `screenId` varchar(255) NOT NULL,
  `seats` int(11) NOT NULL COMMENT 'It can hold the calculated nr of seats for a screen.',
  `movie_movieId` int(11) DEFAULT NULL,
  `screeningdates_screeningDatesId` int(11) DEFAULT NULL,
  PRIMARY KEY (`screenId`),
  KEY `screeningDatesId_FK_idx` (`screeningdates_screeningDatesId`),
  KEY `movieId_FK_idx` (`movie_movieId`),
  CONSTRAINT `movieId_FK` FOREIGN KEY (`movie_movieId`) REFERENCES `Movie` (`movieId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `screeningDatesId_FK` FOREIGN KEY (`screeningdates_screeningDatesId`) REFERENCES `ScreeningDates` (`screeningDatesId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Screen`
--

LOCK TABLES `Screen` WRITE;
/*!40000 ALTER TABLE `Screen` DISABLE KEYS */;
INSERT INTO `Screen` VALUES ('T1',20,1003,3),('T10',30,1106,26),('T11',30,1082,27),('T2',10,1002,2),('T3',30,1057,9),('T4',30,1019,10),('T5',30,1060,11),('T6',30,1062,21),('T7',30,1026,22),('T8',30,1067,24),('T9',30,1067,25);
/*!40000 ALTER TABLE `Screen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningDates`
--

DROP TABLE IF EXISTS `ScreeningDates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ScreeningDates` (
  `screeningDatesId` int(11) NOT NULL AUTO_INCREMENT,
  `screeningDate` datetime DEFAULT NULL,
  `venues_venuesId` int(11) DEFAULT NULL,
  `movieId` int(11) DEFAULT NULL,
  PRIMARY KEY (`screeningDatesId`),
  UNIQUE KEY `screeningDatesId_UNIQUE` (`screeningDatesId`),
  UNIQUE KEY `venues_venuesId_UNIQUE` (`venues_venuesId`),
  KEY `screeningDatesId_INDEX` (`screeningDatesId`),
  KEY `screeningDate_INDEX` (`screeningDate`),
  KEY `venues_venuesId_INDEX` (`venues_venuesId`),
  CONSTRAINT `venues_FK` FOREIGN KEY (`venues_venuesId`) REFERENCES `Venues` (`venuesId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningDates`
--

LOCK TABLES `ScreeningDates` WRITE;
/*!40000 ALTER TABLE `ScreeningDates` DISABLE KEYS */;
INSERT INTO `ScreeningDates` VALUES (2,'2019-09-02 08:00:00',2,1002),(3,'2019-12-16 13:00:00',3,1003),(9,'2019-12-12 21:00:00',10,1057),(10,'2019-11-11 18:00:00',11,1019),(11,'2019-10-10 00:00:00',12,1060),(21,'2019-12-14 04:42:15',21,1062),(22,'2019-12-14 10:11:31',22,1026),(24,'2019-12-14 14:52:31',24,1067),(25,'2019-12-14 15:33:44',25,1067),(26,'2019-12-17 10:02:56',26,1106),(27,'2019-12-31 04:25:10',27,1082);
/*!40000 ALTER TABLE `ScreeningDates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Seats`
--

DROP TABLE IF EXISTS `Seats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Seats` (
  `seatId` int(11) NOT NULL AUTO_INCREMENT,
  `seatNumber` varchar(45) DEFAULT NULL,
  `seatRow` varchar(45) DEFAULT NULL,
  `isReserved` varchar(1) DEFAULT NULL,
  `screen_screenId` varchar(255) DEFAULT NULL,
  `price` varchar(45) NOT NULL,
  `tax` varchar(45) NOT NULL,
  PRIMARY KEY (`seatId`),
  UNIQUE KEY `seatId_UNIQUE` (`seatId`),
  KEY `seatNumber_INDEX` (`seatNumber`),
  KEY `screen_screenId_INDEX` (`screen_screenId`),
  CONSTRAINT `screenId_In_Seats_FK` FOREIGN KEY (`screen_screenId`) REFERENCES `Screen` (`screenId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Seats`
--

LOCK TABLES `Seats` WRITE;
/*!40000 ALTER TABLE `Seats` DISABLE KEYS */;
INSERT INTO `Seats` VALUES (4,'A1','1','1','T2','890','1.25'),(5,'A2','1','1','T2','890','1.25'),(6,'A3','1','1','T2','890','1.25'),(7,'A4','1','1','T2','890','1.25'),(8,'A5','1','0','T2','890','1.25'),(9,'B1','2','1','T2','890','1.25'),(10,'B2','2','1','T2','890','1.25'),(11,'B3','2','1','T2','890','1.25'),(12,'B4','2','1','T2','890','1.25'),(13,'B5','2','1','T2','890','1.25'),(14,'A1','1','1','T1','990','1.25'),(15,'A2','1','1','T1','990','1.25'),(16,'A3','1','1','T1','990','1.25'),(17,'A4','1','1','T1','990','1.25'),(18,'A5','1','0','T1','990','1.25'),(19,'B1','2','0','T1','990','1.25'),(20,'B2','2','0','T1','990','1.25'),(21,'B3','2','0','T1','990','1.25'),(22,'B4','2','0','T1','990','1.25'),(23,'B5','2','0','T1','990','1.25'),(24,'C1','3','1','T2','1002','1.33'),(25,'C2','3','1','T2','1002','1.33'),(26,'C3','3','1','T2','1002','1.33'),(27,'C4','3','1','T2','1002','1.33'),(28,'C5','3','1','T2','1002','1.33'),(29,'D1','4','1','T2','1002','1.33'),(30,'D2','4','1','T2','1002','1.33'),(31,'D3','4','1','T2','1002','1.33'),(32,'D4','4','1','T2','1002','1.33'),(33,'D5','4','1','T2','1002','1.33'),(34,'A1','1','0','T4','1002','1.33'),(35,'A2','1','0','T4','1002','1.33'),(36,'A3','1','0','T4','1002','1.33'),(37,'A4','1','0','T4','1002','1.33'),(38,'A5','1','0','T4','1002','1.33'),(39,'B1','2','1','T4','1002','1.33'),(40,'B2','2','1','T4','1002','1.33'),(41,'B3','2','0','T4','1002','1.33'),(42,'B4','2','0','T4','1002','1.33'),(43,'B5','2','0','T4','1002','1.33'),(44,'A1','1','1','T5','1002','1.33'),(45,'A2','1','1','T5','1002','1.33'),(46,'A3','1','0','T5','1002','1.33'),(47,'A4','1','0','T5','1002','1.33'),(48,'A5','1','0','T5','1002','1.33'),(49,'B1','2','0','T5','1002','1.33'),(50,'B2','2','0','T5','1002','1.33'),(51,'B3','2','0','T5','1002','1.33'),(52,'B4','2','0','T5','1002','1.33'),(53,'B5','2','0','T5','1002','1.33'),(54,'C1','3','0','T5','1002','1.33'),(55,'C2','3','0','T5','1002','1.33'),(56,'C3','3','0','T5','1002','1.33'),(57,'C4','3','0','T5','1002','1.33'),(58,'C5','3','0','T5','1002','1.33'),(59,'D1','4','0','T5','1002','1.33'),(60,'D2','4','0','T5','1002','1.33'),(61,'D3','4','0','T5','1002','1.33'),(62,'D4','4','0','T5','1002','1.33'),(63,'D5','4','0','T5','1002','1.33'),(74,'A1','1','1','T3','1002','1.33'),(75,'A2','1','1','T3','1002','1.33'),(76,'A3','1','1','T3','1002','1.33'),(77,'A4','1','1','T3','1002','1.33'),(78,'A5','1','0','T3','1002','1.33'),(79,'B1','2','0','T3','1002','1.33'),(80,'B2','2','0','T3','1002','1.33'),(81,'B3','2','0','T3','1002','1.33'),(82,'B4','2','0','T3','1002','1.33'),(83,'B5','2','0','T3','1002','1.33'),(84,'C1','3','0','T4','1002','1.33'),(85,'C2','3','0','T4','1002','1.33'),(86,'C3','3','0','T4','1002','1.33'),(87,'C4','3','0','T4','1002','1.33'),(88,'C5','3','0','T4','1002','1.33'),(89,'D1','4','0','T4','1002','1.33'),(90,'D2','4','0','T4','1002','1.33'),(91,'D3','4','0','T4','1002','1.33'),(92,'D4','4','0','T4','1002','1.33'),(93,'D5','4','0','T4','1002','1.33'),(94,'A1','1','0','T6','1002','1.33'),(95,'A2','1','0','T6','1002','1.33'),(96,'A3','1','0','T6','1002','1.33'),(97,'A4','1','0','T6','1002','1.33'),(98,'A5','1','0','T6','1002','1.33'),(99,'B1','2','0','T6','1002','1.33'),(100,'B2','2','0','T6','1002','1.33'),(101,'B3','2','0','T6','1002','1.33'),(102,'B4','2','0','T6','1002','1.33'),(103,'B5','2','0','T6','1002','1.33'),(104,'A1','1','0','T7','1002','1.33'),(105,'A2','1','0','T7','1002','1.33'),(106,'A3','1','0','T7','1002','1.33'),(107,'A4','1','0','T7','1002','1.33'),(108,'A5','1','0','T7','1002','1.33'),(109,'B1','2','0','T7','1002','1.33'),(110,'B2','2','0','T7','1002','1.33'),(111,'B3','2','0','T7','1002','1.33'),(112,'B4','2','0','T7','1002','1.33'),(113,'B5','2','0','T7','1002','1.33'),(114,'C1','1','0','T7','1002','1.33'),(115,'C2','1','0','T7','1002','1.33'),(116,'C3','1','0','T7','1002','1.33'),(117,'C4','1','0','T7','1002','1.33'),(118,'C5','1','0','T7','1002','1.33'),(129,'A1','1','0','T8','1002','1.33'),(130,'A2','1','0','T8','1002','1.33'),(131,'A3','1','0','T8','1002','1.33'),(132,'A4','1','0','T8','1002','1.33'),(133,'A5','1','0','T8','1002','1.33'),(134,'B1','2','0','T8','1002','1.33'),(135,'B2','2','0','T8','1002','1.33'),(136,'B3','2','0','T8','1002','1.33'),(137,'B4','2','0','T8','1002','1.33'),(138,'B5','2','0','T8','1002','1.33'),(139,'A1','1','0','T9','1002','1.33'),(140,'A2','1','0','T9','1002','1.33'),(141,'A3','1','0','T9','1002','1.33'),(142,'A4','1','0','T9','1002','1.33'),(143,'A5','1','0','T9','1002','1.33'),(144,'B1','2','0','T9','1002','1.33'),(145,'B2','2','0','T9','1002','1.33'),(146,'B3','2','0','T9','1002','1.33'),(147,'B4','2','0','T9','1002','1.33'),(148,'B5','2','0','T9','1002','1.33'),(149,'A1','1','0','T10','1002','1.33'),(150,'A2','1','0','T10','1002','1.33'),(151,'A3','1','0','T10','1002','1.33'),(152,'A4','1','0','T10','1002','1.33'),(153,'A5','1','0','T10','1002','1.33'),(154,'B1','2','0','T10','1002','1.33'),(155,'B2','2','0','T10','1002','1.33'),(156,'B3','2','1','T10','1002','1.33'),(157,'B4','2','1','T10','1002','1.33'),(158,'B5','2','0','T10','1002','1.33'),(159,'A1','1','0','T11','1002','1.33'),(160,'A2','1','0','T11','1002','1.33'),(161,'A3','1','0','T11','1002','1.33'),(162,'A4','1','0','T11','1002','1.33'),(163,'A5','1','0','T11','1002','1.33'),(164,'B1','2','0','T11','1002','1.33'),(165,'B2','2','0','T11','1002','1.33'),(166,'B3','2','0','T11','1002','1.33'),(167,'B4','2','0','T11','1002','1.33'),(168,'B5','2','0','T11','1002','1.33');
/*!40000 ALTER TABLE `Seats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ticket`
--

DROP TABLE IF EXISTS `Ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ticket` (
  `ticketId` int(20) NOT NULL AUTO_INCREMENT,
  `price` int(11) NOT NULL,
  `tax` varchar(45) DEFAULT NULL,
  `screen_screenId` varchar(255) DEFAULT NULL,
  `seats_seatNumber` varchar(45) DEFAULT NULL,
  `seats_seatRow` varchar(45) DEFAULT NULL,
  `seats_seatId` int(11) DEFAULT NULL,
  `purchase_purchaseId` int(20) DEFAULT NULL,
  PRIMARY KEY (`ticketId`),
  KEY `screenId_FK` (`screen_screenId`),
  KEY `ticketId_Ticket_FK_idx` (`purchase_purchaseId`),
  CONSTRAINT `purchase_Ticket_FK` FOREIGN KEY (`purchase_purchaseId`) REFERENCES `Purchase` (`purchaseId`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `screenId_Ticket_FK` FOREIGN KEY (`screen_screenId`) REFERENCES `Screen` (`screenId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ticket`
--

LOCK TABLES `Ticket` WRITE;
/*!40000 ALTER TABLE `Ticket` DISABLE KEYS */;
INSERT INTO `Ticket` VALUES (90,1002,'1.33','T5','A2','1',45,77),(91,1002,'1.33','T5','A1','1',44,77),(92,1002,'1.33','T4','B1','2',39,78),(93,1002,'1.33','T4','B2','2',40,78),(99,1002,'1.33','T10','B3','2',156,82),(100,1002,'1.33','T10','B4','2',157,82),(121,990,'1.25','T1','A3','1',16,101),(122,990,'1.25','T1','A1','1',14,101),(123,990,'1.25','T1','A2','1',15,101),(124,990,'1.25','T1','A4','1',17,101),(125,1002,'1.33','T3','A1','1',74,102),(126,1002,'1.33','T3','A3','1',76,102),(127,1002,'1.33','T3','A4','1',77,102),(128,1002,'1.33','T3','A2','1',75,102),(129,890,'1.25','T2','A2','1',5,103),(130,890,'1.25','T2','A4','1',7,103),(131,890,'1.25','T2','A3','1',6,103),(132,890,'1.25','T2','A1','1',4,103),(133,1002,'1.33','T2','C3','3',26,104),(134,1002,'1.33','T2','C4','3',27,104),(135,890,'1.25','T2','B3','2',11,104),(136,1002,'1.33','T2','D1','4',29,104),(137,1002,'1.33','T2','C2','3',25,104),(138,1002,'1.33','T2','D3','4',31,104),(139,890,'1.25','T2','B4','2',12,104),(140,890,'1.25','T2','B5','2',13,104),(141,890,'1.25','T2','B2','2',10,104),(142,1002,'1.33','T2','D2','4',30,104),(143,1002,'1.33','T2','C5','3',28,104),(144,1002,'1.33','T2','C1','3',24,104),(145,890,'1.25','T2','B1','2',9,104),(146,1002,'1.33','T2','D4','4',32,104),(147,1002,'1.33','T2','D5','4',33,104);
/*!40000 ALTER TABLE `Ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Venues`
--

DROP TABLE IF EXISTS `Venues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Venues` (
  `venuesId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `contact` varchar(45) DEFAULT NULL,
  `venues_picture` varchar(45) DEFAULT NULL,
  `screen_screenId` varchar(255) DEFAULT NULL,
  `location_locationId` int(11) DEFAULT NULL,
  PRIMARY KEY (`venuesId`),
  KEY `screenId_FK_idx` (`screen_screenId`),
  KEY `locationId_FK_idx` (`location_locationId`),
  CONSTRAINT `locationId_FK` FOREIGN KEY (`location_locationId`) REFERENCES `location` (`locationId`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `screenId_FK` FOREIGN KEY (`screen_screenId`) REFERENCES `Screen` (`screenId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Venues`
--

LOCK TABLES `Venues` WRITE;
/*!40000 ALTER TABLE `Venues` DISABLE KEYS */;
INSERT INTO `Venues` VALUES (2,'Corvin Mozi','The Tower of London','Yeoman Warder','/images/venues/corvin2_med.jpg','T2',3),(3,'Cinema City Allee','Budapest, Allee bevásárlóközpont, Október huszonharmadika u. 8-10, 1117 Magyarország','ET','/images/venues/cinemacity03.jpg','T1',10),(10,'Corvin Mozi','The Tower of London','Yeoman Warder','/images/venues/corvin2_med.jpg','T3',3),(11,'Cinema City Allee','Budapest, Allee bevásárlóközpont, Október huszonharmadika u. 8-10, 1117 Magyarország','ET','/images/venues/cinemacity03.jpg','T4',10),(12,'Müvész Mozi','Budapest, Teréz krt. 30, 1066 Magyarország','Quentin Tarantino','/images/venues/muvesz_mozi.jpg','T5',6),(21,'Müvész Mozi','Budapest, Teréz krt. 30, 1066 Magyarország','Quentin Tarantino','/images/venues/muvesz_mozi.jpg','T6',6),(22,'Uránia Filmszínház','Budapest, Rákóczi út 21, 1088 Magyarország','Tim Roth','/images/venues/urania_mozi.jpg','T7',2),(24,'Uránia Filmszínház','Budapest, Rákóczi út 21, 1088 Magyarország','Tim Roth','/images/venues/urania_mozi.jpg','T8',2),(25,'Müvész Mozi','Budapest, Teréz krt. 30, 1066 Magyarország','Quentin Tarantino','/images/venues/muvesz_mozi.jpg','T9',6),(26,'Cinema City Allee','Budapest, Allee bevásárlóközpont, Október huszonharmadika u. 8-10, 1117 Magyarország','ET','/images/venues/cinemacity03.jpg','T10',10),(27,'Uránia Filmszínház','Budapest, Rákóczi út 21, 1088 Magyarország','Tim Roth','/images/venues/urania_mozi.jpg','T11',2);
/*!40000 ALTER TABLE `Venues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `locationId` int(11) NOT NULL AUTO_INCREMENT,
  `formatted_address` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `latitude` varchar(45) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `longitude` varchar(45) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`locationId`),
  UNIQUE KEY `locationId_UNIQUE` (`locationId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'Budapest, Alkotás u. 53, Magyarország','Cinema City Mom Park','47.4909131','19.0241229','2016-07-03 23:03:28'),(2,'Budapest, Rákóczi út 21, 1088 Magyarország','Uránia Filmszínház','47.4953832','19.0651162','2016-07-03 23:03:28'),(3,'Budapest, Corvin köz 1, 1082 Magyarország','Corvin Mozi','47.4861873','19.0713004','2016-07-03 23:03:28'),(4,'Budapest, Balassi Bálint u. 15-17, 1055 Magyarország','Cirko-Gejzír Filmszínház','47.51110320000001','19.0473337','2016-07-03 23:03:28'),(5,'Budapest, Kossuth Lajos u. 18, 1053 Magyarország','Puskin Mozi','47.49404209999999','19.0583964','2016-07-03 23:03:28'),(6,'Budapest, Teréz krt. 30, 1066 Magyarország','Művész Mozi','47.5065963','19.0611456','2016-07-03 23:03:28'),(7,'Budapest, Nagytétényi út 37-43, 1225 Magyarország','Cinema City Campona','47.4075062','19.0183425','2016-07-03 23:03:28'),(8,'Budapest, Váci út 22-24, 1132 Magyarország','I.T. Magyar Cinema Kft.','47.51413579999999','19.05828959999999','2016-07-03 23:03:28'),(9,'Budapest, Lövőház u. 2-6, 1024 Magyarország','Palace Mammut','47.50859999999999','19.0258','2016-07-03 23:03:28'),(10,'Budapest, Allee bevásárlóközpont, Október huszonharmadika u. 8-10, 1117 Magyarország','Cinema City Allee','47.4754174','19.0488664','2016-07-03 23:03:28'),(11,'Budapest, Kazinczy u. 14, 1075 Magyarország','Szimpla Kertmozi','47.496889','19.0632701','2016-07-03 23:03:28'),(12,'Budapest, Erzsébet krt. 39, 1074 Magyarország','Örökmozgó Filmmúzeum','47.5018675','19.0675644','2016-07-03 23:03:28'),(13,'Budapest, Hollán Ernő u. 7., 1136 Magyarország','Odeon Lloyd Mozi','47.5137753','19.0498709','2016-07-03 23:03:28');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `tickets_per_user_per_purchase`
--

DROP TABLE IF EXISTS `tickets_per_user_per_purchase`;
/*!50001 DROP VIEW IF EXISTS `tickets_per_user_per_purchase`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `tickets_per_user_per_purchase` AS SELECT 
 1 AS `user`,
 1 AS `movieId`,
 1 AS `movie`,
 1 AS `venue`,
 1 AS `secreenId`,
 1 AS `date`,
 1 AS `purchaseId`,
 1 AS `ticketId`,
 1 AS `seatId`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'book'
--
/*!50003 DROP FUNCTION IF EXISTS `is_id_in_ids` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `is_id_in_ids`(`strIDs` VARCHAR(255),`_id` BIGINT) RETURNS bit(1)
BEGIN

  DECLARE strLen    INT DEFAULT 0;
  DECLARE subStrLen INT DEFAULT 0;
  DECLARE subs      VARCHAR(255);

  IF strIDs IS NULL THEN
    SET strIDs = '';
  END IF;

  do_this:
    LOOP
      SET strLen = LENGTH(strIDs);
      SET subs = SUBSTRING_INDEX(strIDs, ',', 1);

      if ( CAST(subs AS UNSIGNED) = _id ) THEN
        -- founded
        return(1);
      END IF;

      SET subStrLen = LENGTH(SUBSTRING_INDEX(strIDs, ',', 1));
      SET strIDs = MID(strIDs, subStrLen+2, strLen);

      IF strIDs = NULL or trim(strIds) = '' THEN
        LEAVE do_this;
      END IF;

  END LOOP do_this;

RETURN 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `tickets_per_user_per_purchase`
--

/*!50001 DROP VIEW IF EXISTS `tickets_per_user_per_purchase`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `tickets_per_user_per_purchase` AS select `purchase`.`uuid` AS `user`,`movie`.`movieId` AS `movieId`,`movie`.`name` AS `movie`,`venues`.`name` AS `venue`,`screen`.`screenId` AS `secreenId`,`screeningdates`.`screeningDate` AS `date`,`purchase`.`purchaseId` AS `purchaseId`,`ticket`.`ticketId` AS `ticketId`,`seats`.`seatId` AS `seatId` from ((((((`movie` join `screen` on((`screen`.`movie_movieId` = `movie`.`movieId`))) join `screeningdates` on((`screeningdates`.`screeningDatesId` = `screen`.`screeningdates_screeningDatesId`))) join `ticket` on((`ticket`.`screen_screenId` = `screen`.`screenId`))) join `purchase` on((`purchase`.`purchaseId` = `ticket`.`purchase_purchaseId`))) join `seats` on((`seats`.`seatId` = `ticket`.`seats_seatId`))) join `venues` on((`venues`.`screen_screenId` = `screen`.`screenId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-04  0:30:59
