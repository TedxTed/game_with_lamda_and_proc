# 定義一個遊戲地點
locations = {
  forest: {
    description: '你來到了一片深沉的森林。',
    event: lambda { |player|
      if rand < 0.5
        puts '你被野獸攻擊！'
        player[:health] -= 10
      else
        puts '你在森林中找到了一個寶藏箱！'
        player[:inventory] << '寶藏'
      end
    }
  }
}

# 定義行動
actions = {
  go: proc do |player, location|
    if locations.include?(location)
      puts locations[location][:description]
      locations[location][:event].call(player)
    else
      puts '你不能去那裡！'
    end
  end,
  heal: proc do |player|
    if player[:inventory].include?('healing potion')
      player[:health] += 20
      player[:inventory].delete('healing potion')
      puts '你使用了治療藥劑，生命值恢復了 20 點！'
    else
      puts '你沒有治療藥劑！'
    end
  end,
  attack: proc do |player, target|
    if rand < 0.5
      target[:health] -= 10
      player[:inventory] << 'healing potion'
      puts "你成功攻擊了 #{target[:name]}！"
    else
      puts '你的攻擊失敗了！'
    end
  end
  # 可以添加更多的行動...
}

# 定義玩家
player = {
  name: '冒險者',
  health: 100,
  inventory: []
}

target = {
  name: 'monster',
  health: 1000
}

# 遊戲主循環
while player[:health] > 0
  puts '請選擇你要執行的行動：'
  action = gets.chomp.to_sym

  if actions.include?(action)
    # 如果行動是 'go'，那麼需要讓玩家選擇他們想去的地點
    if action == :go
      puts '你想去哪裡？'
      location = gets.chomp.to_sym
      actions[action].call(player, location)
    else
      actions[action].call(player, target) # 假設 target 是一個已經定義的對象
    end
  else
    puts '未知的行動...'
  end

  puts "你現在的狀態：生命值 #{player[:health]}, 物品 #{player[:inventory].join(', ')}"
end

puts '遊戲結束。'
