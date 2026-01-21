local P = {}

-- ハンドラー名（必須）
P.name = "AudioFileをオブジェクトに変換"

-- 優先度（省略時は 1000）
-- 数値が小さいほど先に実行されます
P.priority = 1000

P.audio_exts = {
    "m4a",
    "wav",
    "aiff",
    "flac",
    "wv",
    "alac",
    "aac",
    "mp3",
    "ogg",
    "opus",
    "ac3",
    "wma"
}

function P.drag_enter(files, state)
    -- ドラッグ開始時の処理
    for _, file in ipairs(files) do
        if file.filepath:sub(-4):lower() == ".wav" then
            return true
        end
    end
    return false
end

function P.drag_leave()
    -- ドラッグがタイムラインから離れたときの処理
end

function P.drop(files, state)
    for _, file in ipairs(files) do
        local ext = file.filepath:match("[^.]+$"):lower()
        local is_audio = false
        for key, value in pairs(P.audio_exts) do
            if ext == value then
                is_audio = true
                break
            end
        end
        if not is_audio then
            return false
        end
        local data = gcmz.get_project_data()
        local info = gcmz.get_media_info(file.filepath)
        local duration_sec = 1
        if info and info.total_time then
            duration_sec = info.total_time
        end
        local frame = duration_sec * (data.rate / data.scale)
        local obj = [[
[0]
layer=0
frame=0,]] .. frame .. [[
group=1
[0.0]
effect.name=音声ファイル
再生位置=0.000
再生速度=100.00
ファイル=]] .. file.filepath .. [[
トラック=0
ループ再生=0
[0.1]
effect.name=音声再生
音量=100.00
左右=0.00
[1]
layer=1
frame=0,]] .. frame .. [[
group=1
[1.0]
effect.name=セリフ準備@PSDToolKit
キャラクターID=file_name_0
テキスト=]] .. file.filepath:match("[^/\\]+$"):match(".+[^.]$") .. [[
音声ファイル=]] .. file.filepath .. [[
[1.1]
effect.name=標準描画
描画.hide=1
X=0.00
Y=0.00
Z=0.00
Group=1
中心X=0.00
中心Y=0.00
中心Z=0.00
X軸回転=0.00
Y軸回転=0.00
Z軸回転=0.00
拡大率=100.000
縦横比=0.000
透明度=0.00
合成モード=通常
]]
        table.remove(files, key)
        local temp_path = gcmz.create_temp_file("wav2obj.object")
        -- ファイルに何か処理を行う
        table.insert(files, {
            filepath = temp_path,
            mimetype = "",
            temporary = true  -- 一時ファイルとしてマーク
        })
        return true
    end
    return false
end

return P
