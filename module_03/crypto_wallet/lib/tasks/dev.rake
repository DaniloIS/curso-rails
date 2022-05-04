namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando DB...") { %x(rails db:drop) }

      show_spinner("Criando DB...") { %x(rails db:create) }

      show_spinner("Migrando DB...") { %x(rails db:migrate) }

      show_spinner("Populando DB...") { %x(rails db:seed) }
    else
      puts "Você não está em modo de desenvolvimento!"
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
