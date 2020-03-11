//PureDataへの命令
import netP5.*;
import oscP5.*;
OscP5 oscP5;
NetAddress oscDestination;

// Minim を使用する準備
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
float     sampleRate;  

PrintWriter output;

// オーディオ入力の変数
AudioInput in;

// FFTの変数
FFT fft;

int  count = 0;//秒数カウント

void setup()
{
  
   frameRate(50);
  oscP5=new OscP5(this,8001);
oscDestination=new NetAddress("localhost",8001);
 
  // キャンバスサイズを指定
  size(600, 300);

  // Minim を初期化
  minim = new Minim(this);

  // ステレオオーディオ入力を取得、バッファサイズ８１９２でオーディオ入力音を取得するように指定
  in = minim.getLineIn(Minim.STEREO, 8192);


  // ステレオオーディオ入力を FFT と関連づけ　fft = new FFT(in.bufferSize(), in.sampleRate());
  fft = new FFT(8192, 96000);
  //分割個数4097
 
 

 //String filename = nf(, 4) + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) ;
  // 新しいファイルを生成
  output = createWriter( 2222 + ".csv");
  
  // output.println(1);//目的変数確定（一行目）
   
   /* for(int i = 0; i < fft.specSize(); i++)
        {
              //  println(i + " = " + fft.getBandWidth()*i + " ~ "+ fft.getBandWidth()*(i+1));
        }*/
}

void draw()
{
   OscMessage myMessage = new OscMessage("/p5/p52");

     myMessage.add(1);
    
  oscP5.send(myMessage,oscDestination);
    
  count++;
 // println(count);
  // 背景色を黒に設定
  background(0);

  // 線の色を白に設定
  stroke(255);

  // FFT 実行
  fft.forward(in.mix);

  // FFTのスペクトラムの幅を変数に保管
  int specSize = fft.specSize();

  // 棒グラフを描画
  for (int i = 0; i < specSize; i++)
  {
    // x をスペクトラム幅に応じた位置として取得
    float x = map(i, 0, specSize, 0, width);

    // fft.getBand(i) で、個別のスペクトラムの値を取得し、
    // 取得した値に応じた線を描く
    line(x, height, x, height - fft.getBand(i) * 100000);
    if(i==3416){
      stroke(0,255,0);
    }

  }
  if(count>250){

  for(int i=3414;i<4096;i++){
   // 40-48kHzの部分をcsvに書き込む     
  output.println(fft.getBand(i));
   }
   }
 if(count>=500){
    output.flush(); 
    output.close(); 
    exit();
  }
  println(count);
}



// プログラム終了時の処理
void stop()
{
  minim.stop();
  super.stop();
}
