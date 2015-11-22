PImage healthPoint , treasure , outerSpace1 , outerSpace2 , enemy , fighter , start1 , start2 , end1 , end2 ;
int xOuterSpace , hpAmount , enemySpeed , xTreasure , yTreasure , xFighter , yFighter ;
float xEnemy , yEnemy ;
final int GAME_START=1 , GAME_RUN=2 , GAME_LOSE=3 , fullHp = 205 ;
int gameState ;
boolean upPressed = false , downPressed = false , leftPressed = false , rightPressed = false , spacePressed = false ;

final int nbrEnemies = 5 , shootSpeed = 10 ;
final float spacing = 480/(1.5*nbrEnemies) ;

boolean[]enemy1 = new boolean[nbrEnemies];
boolean[]enemy2 = new boolean[nbrEnemies];
boolean[]enemy3 = new boolean[8];

int nbrShoot ;
boolean[]bullet = new boolean[nbrShoot];
int []xBullet = new int[nbrShoot];
int []yBullet = new int[nbrShoot];

float[]x1 = new float [nbrEnemies] ;
float[]x2 = new float [nbrEnemies] ;
float[]x3 = new float [8] ;
float[]y1 = new float [nbrEnemies] ;
float[]y2 = new float [nbrEnemies] ;
float[]y3 = new float [8] ;

int numFrames = 5 ;
int currentFrame ;
boolean []flame = new boolean[numFrames];
PImage []flameImg = new PImage[numFrames];


void setup () {

  size(640,480) ; 
  
  outerSpace1 = loadImage("img/bg1.png") ;  outerSpace2 = loadImage("img/bg2.png") ;  xOuterSpace = 0 ;
  healthPoint = loadImage("img/hp.png") ;  hpAmount = fullHp/5 ;
  treasure = loadImage("img/treasure.png") ;  xTreasure = floor(random(100,600)) ;  yTreasure = floor(random(100,400)) ;
  enemy = loadImage("img/enemy.png") ;   xEnemy = -enemy.width/2 ;  yEnemy = floor(random(60,420)) ;  enemySpeed = floor(random(4,7)) ;
  fighter = loadImage("img/fighter.png") ;  xFighter = 550 ;  yFighter = 300 ;
  start1 = loadImage("img/start1.png") ;  start2 = loadImage("img/start2.png") ;  end1 = loadImage("img/end1.png") ;  end2 = loadImage("img/end2.png") ;

  gameState = GAME_START ; 

  nbrShoot = 5 ;

  currentFrame = 0;
  for (int i=0; i<numFrames; i++){ flameImg[i] = loadImage("img/flame" + (i+1) + ".png"); }
  frameRate(60) ;
 
  for(int i = 0 ; i<5 ; i++){
  xBullet[i] = -1000 ;
  yBullet[i] = -1000 ;
  }
  
  for(int i = 0 ;i<5 ; i++){
  enemy1[i] = true;
  enemy2[i]=true;
  bullet[i]=false;
  }
  
  for(int i = 0 ; i<8 ; i++){
  enemy3[i]=true ;
  }
  
  }
  
  




void draw() {
  
  switch (gameState){
    
    case GAME_START:   
    if ( 190 < mouseX && mouseX < 450 && 370 < mouseY && mouseY < 410) {
      image(start1,0,0) ; 
      if(mousePressed){
        gameState = GAME_RUN ;
        }
      }else{
      image(start2,0,0) ;
    }       
      break ;   
    
    case GAME_RUN :  
    if(upPressed){ yFighter -= 15 ; }
    if(downPressed){ yFighter += 15 ; }
    if(leftPressed){ xFighter -= 15 ; }
    if(rightPressed){ xFighter += 15 ; }
    //boundary detection
    if (xFighter > 640-fighter.width ) { xFighter = 640-fighter.width ; }
    if (xFighter < 0 ) { xFighter = 0 ; }
    if (yFighter > 480-fighter.height ) { yFighter = 480-fighter.height ; }
    if (yFighter < 0 ) { yFighter = 0 ; }
    //outer space  
    image(outerSpace2,xOuterSpace,0) ;
    image(outerSpace1,xOuterSpace-outerSpace2.width,0) ;
    image(outerSpace2,xOuterSpace-outerSpace2.width-outerSpace1.width,0) ;
    xOuterSpace++ ;
    xOuterSpace %= (outerSpace2.width+outerSpace1.width) ;
    //health point
    fill(255,0,0);
    rect(45, 10, hpAmount, 30, 25) ;
    image(healthPoint,40,10) ;  
    //treasure
    image(treasure, xTreasure, yTreasure) ;
    if ( xTreasure-treasure.width/2-fighter.width/2 < xFighter && xFighter < xTreasure+treasure.width/2+fighter.width/2
    && yTreasure-treasure.height/2-fighter.height/2 < yFighter && yFighter < yTreasure+treasure.height/2+fighter.height/2
    && hpAmount < fullHp-fullHp/10 ) {
        hpAmount = hpAmount+fullHp/10 ;
        xTreasure = floor(random(100,600)) ;
        yTreasure = floor(random(100,400)) ;
    }else if( xTreasure-treasure.width/2-fighter.width/2 < xFighter && xFighter < xTreasure+treasure.width/2+fighter.width/2
    && yTreasure-treasure.height/2-fighter.height/2 < yFighter && yFighter < yTreasure+treasure.height/2+fighter.height/2
    && hpAmount >= fullHp-fullHp/10) {
      hpAmount = fullHp;
      xTreasure = floor(random(100,600)) ;
      yTreasure = floor(random(100,400)) ;  
    }
    //fighter
    image(fighter,xFighter,yFighter); 
    if ( xEnemy-enemy.width/2-fighter.width/2 < xFighter && xFighter < xEnemy+enemy.width/2+fighter.width/2 
    && yEnemy-enemy.height/2-fighter.height/2 < yFighter && yFighter < yEnemy+enemy.height/2+fighter.height/2 ) {
      hpAmount = hpAmount - fullHp/5 ;
    }
    if( hpAmount <= 0 ){
      gameState = GAME_LOSE ;
    }    
    //health point
    fill(255,0,0);
    rect(45, 10, hpAmount, 30, 25) ;
    image(healthPoint,40,10) ;  

    if (frameCount % (60/5) == 0){
    int i = (currentFrame ++) % numFrames;
    image(flameImg[i], 0, 0);
    }

    for(int i=0; i<5 ; i++){
      if (enemy1[i]){
        if(y1[i]>=yFighter-fighter.height&&y1[i]<=yFighter+fighter.height&&x1[i]>=xFighter-fighter.width&&x1[i]<=xFighter+fighter.width){
          enemy1[i]=false;
          flame[0]=true;
            for(int j=0 ; j<5 ; j++){
            if(j>0){ flame[j]=true; flame[j-1]=false; }
            if(flame[j]){ image(flameImg[j],x1[i],y1[i]) ; }
            }
            x1[i]=-100;
            y1[i]=-100;
            hpAmount -= fullHp/5 ;
          }
       }
       if(enemy2[i]){
        if(y2[i]>=yFighter-fighter.height&&y2[i]<=yFighter+fighter.height&&x2[i]>=xFighter-fighter.width&&x2[i]<=xFighter+fighter.width){
          enemy2[i]=false;
          flame[0]=true;
            for(int j=0 ; j<5 ; j++){
            if(j>0){ flame[j]=true; flame[j-1]=false; }
            if(flame[j]){ image(flameImg[j],x2[i],y2[i]) ; }
            }
            x2[i]=-100;
            y2[i]=-100;
            hpAmount -= fullHp/5 ;
        }
       }
     }
     for(int i=0; i<8 ; i++){
      if (enemy3[i]){
        if(y3[i]>=yFighter-fighter.height&&y3[i]<=yFighter+fighter.height&&x3[i]>=xFighter-fighter.width&&x3[i]<=xFighter+fighter.width){
          enemy3[i]=false;
          flame[0]=true;
            for(int j=0 ; j<5 ; j++){
            if(j>0){ flame[j]=true; flame[j-1]=false; }
            if(flame[j]){ image(flameImg[j],x3[i],y3[i]) ; }
            }
            x3[i]=-100;
            y3[i]=-100;
            hpAmount -= fullHp/5 ;
          }
        }
      }
      
      break ; 
 
    case GAME_LOSE :
     if ( 200 < mouseX && mouseX < 440 && 310 < mouseY && mouseY < 350) {
      image(end1,0,0) ; 
      if(mousePressed){
        for(int i=0 ; i<5 ; i++ ){
          enemy1[i]=true;
          enemy2[i]=true;
          bullet[i]=false;
          }
        for(int i=0 ; i<8 ; i++){
          enemy3[i]=true;
          }
        for(int i=0 ; i<5 ; i++ ){
          xBullet[i]=-1000;
          yBullet[i]=-1000;
          }
        hpAmount = fullHp/5 ;
        xFighter = 550 ; 
        yFighter = 300 ;
        nbrShoot = 5 ;
        xEnemy = -300 ; yEnemy =floor(random(100,400)) ;
        gameState = GAME_RUN ;
        }
      }else{
      image(end2,0,0) ;
        }          
      break ;
      
  }  }
    
    void keyPressed() {
      if (key == ' ')
      {
       }
      
     
      
      if (key == CODED) {
        switch(keyCode){
          case UP :   upPressed = true ;   break ;
          case DOWN :   downPressed = true ;   break ;
          case LEFT :   leftPressed = true ;   break ;
          case RIGHT :   rightPressed = true ;   break ;
          
        }
      }
    }
    void keyReleased(){
      if(key == CODED) {
        switch(keyCode){
          case UP :   upPressed = false ;   break ;
          case DOWN :   downPressed = false ;   break ;
          case LEFT :   leftPressed = false ;   break ;
          case RIGHT :   rightPressed = false ;   break ;
        }
      }
    }
