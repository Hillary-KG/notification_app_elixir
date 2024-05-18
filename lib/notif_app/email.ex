# some/path/within/your/app/email.ex
defmodule MyApp.Email do
  import Bamboo.Email

  def build_email(subject  \\ "General", recipient, message) do
      base_email()
      |> to(recipient)
      |> subject(subject)
      |> html_body("<strong>#{subject}</strong>")
      |> text_body(message)
  end

  def base_email do
    new_email(from: System.get_env("ADMIN_EMAIL"))
  end

  # def send_email(email)
end
