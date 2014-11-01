# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Level.create(:required_exp => 0,:level => 1,:degree => "ビジター")
Level.create(:required_exp => 1,:level => 2,:degree => "こなれてきた人")
Level.create(:required_exp => 5,:level => 3,:degree => "メイト")
Level.create(:required_exp => 10,:level => 4,:degree => "褒め中級者")
Level.create(:required_exp => 16,:level => 5,:degree => "褒め茶帯")
Level.create(:required_exp => 23,:level => 6,:degree => "褒め初段")
Level.create(:required_exp => 31,:level => 7,:degree => "褒め師匠")
Level.create(:required_exp => 39,:level => 8,:degree => "マスター")
Level.create(:required_exp => 46,:level => 9,:degree => "褒め免許皆伝")
Level.create(:required_exp => 55,:level => 10,:degree => "FocusMater")
Level.create(:required_exp => 75,:level => 11,:degree => "想定外の承認者")
Level.create(:required_exp => 100,:level => 12,:degree => "新境地への挑戦者")
Level.create(:required_exp => 125,:level => 13,:degree => "作成者の誇り")
Level.create(:required_exp => 150,:level => 14,:degree => "逆に本当に褒めているのか")
Level.create(:required_exp => 175,:level => 15,:degree => "作成者への逆反逆者")