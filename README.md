# [GCMZDrops2](https://github.com/oov/aviutl2_gcmzdrops2)のハンドラースクリプト集
- ## audio2obj.lua
  ### 概要
  Altキーを押下しながらドロップした音声ファイルのファイル名からセリフ準備@PSDToolKitオブジェクトと音声オブジェクトのobjectファイルを生成する。  
  filesから音声ファイルを除きobjectファイルを追加した状態になる
  ### 設定
  - use_alt_key: Altキー押下時のみ有効化するかどうか（デフォルト:true）
  - set_character_id: 
    - switch:セリフ準備@PSDToolKitオブジェクトのキャラクターIDをファイル名から設定するかどうか（デフォルト:false）
    - splitstr: キャラクターIDとセリフテキストを分割する文字列（デフォルト:"_"）
- ## midi2EAP2.lua
  ### 概要
  ドロップしたmidiファイルからExternal Audio Processing 2 MIDI Visualizerオブジェクトのobjectファイルを生成する。  
  Altキーを押下しながらドロップしたmidiファイルからExternal Audio Processing 2 (Media)オブジェクトのobjectファイルを生成する。  
  再生時間が一番長いトラックに合わせてオブジェクトの長さが設定される
