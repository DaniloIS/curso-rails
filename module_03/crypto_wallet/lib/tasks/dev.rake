namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando DB...") { %x(rails db:drop) }

      show_spinner("Criando DB...") { %x(rails db:create) }

      show_spinner("Migrando DB...") { %x(rails db:migrate) }

      %x(rails dev:mining_types)

      %x(rails dev:add_coins)
      
    else
      puts "Você não está em modo de desenvolvimento!"
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins = [
        {
          description: "Bitcoin",
          acronym: "BTC",
          url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1.png",
          mining_type: MiningType.find_by(acronym: 'PoW')
        }, {
            description: "Ethereum",
            acronym: "ETH",
            url_image: "https://d33wubrfki0l68.cloudfront.net/fcd4ecd90386aeb50a235ddc4f0063cfbb8a7b66/4295e/static/bfc04ac72981166c740b189463e1f74c/40129/eth-diamond-black-white.jpg",
            mining_type: MiningType.all.sample
        }, {
          description: "Dash",
          acronym: "DASH",
          url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/131.png",
          mining_type: MiningType.all.sample
        }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de mineração"
  task mining_types: :environment do
    show_spinner("Cadastrando os tipos de mineração...") do
      mining_types = [
        {
          description: "Proof of Work",
          acronym: "PoW"
        }, {
          description: "Proo of Stake",
          acronym: "PoS"
        }, {
          description: "Proo of Capacity",
          acronym: "PoC"
        }
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private 

  def show_spinner(msg_start, msg_end = "Concluido com sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin

    yield

    spinner.success(msg_end)
  end
end
