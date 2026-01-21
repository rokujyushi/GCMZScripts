local P = {}

-- ハンドラー名（必須）
P.name = "AudioFileをオブジェクトに変換"

-- 優先度（省略時は 1000）
-- 数値が小さいほど先に実行されます
P.priority = 1000

-- 設定項目
P.settings = {
    -- 設定項目の例
    use_alt_key = true, -- Altキーを押下したときのみ有効にする
    set_character_id = {
        switch = false,
        splitstr = "_" -- ファイル名からキャラクターIDを設定する際の区切り文字
    },                 -- キャラクターIDをファイル名に設定する
}
-- 設定項目

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
    for index, file in ipairs(files) do
        local ext = file.filepath:match("[^.]+$"):lower()
        for key, value in pairs(P.audio_exts) do
            if ext == value then
                return true
            end
        end
    end
    return false
end

function P.drag_leave()
    -- ドラッグがタイムラインから離れたときの処理
end

function P.drop(files, state)
    for index, file in ipairs(files) do
        local ext = file.filepath:match("[^.]+$"):lower()
        local is_audio = false
        for key, value in pairs(P.audio_exts) do
            if ext == value and (not P.settings.use_alt_key or state.alt) then
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
        local text = file.filepath:match("([^/\\]+)$"):gsub("%.[^%.]+$", "")
        if P.settings.set_character_id.switch then
            local parts = {}
            for part in string.gmatch(text, "([^" .. P.settings.set_character_id.splitstr .. "]+)") do
                table.insert(parts, part)
            end
            if #parts > 0 then
                text = table.concat(parts, " ", 2) -- 2番目以降をセリフテキストにする
            end
        end
        local obj = [[
[0]
layer=0
frame=0,]] .. frame .. "\r\n" .. [[
group=1
[0.0]
effect.name=音声ファイル
再生位置=0.000
再生速度=100.00
ファイル=]] .. file.filepath .. "\r\n" .. [[
トラック=0
ループ再生=0
[0.1]
effect.name=音声再生
音量=100.00
左右=0.00
[1]
layer=1
frame=0,]] .. frame .. "\r\n" .. [[
group=1
[1.0]
effect.name=セリフ準備@PSDToolKit
キャラクターID=file_name_0
テキスト=]] .. text .. "\r\n" .. [[
音声ファイル=]] .. file.filepath .. "\r\n" .. [[
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
        debug_print(obj)
        table.remove(files, index)
        local temp_path = gcmz.create_temp_file("wav2obj.object")
        local temp_file = io.open(temp_path, "w")
        if temp_file then
            temp_file:write(obj)
            temp_file:close()
        else
            debug_print("一時ファイルの作成に失敗しました: " .. temp_path)
            return false
        end
        -- ファイルに何か処理を行う
        table.insert(files, {
            filepath = temp_path,
            mimetype = "",
            temporary = true -- 一時ファイルとしてマーク
        })
        return true
    end
    return false
end

return P
