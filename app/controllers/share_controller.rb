class ShareController < ApplicationController
  def pilpres
    
  end

  # Example : /share/janjipolitik/9fb657c1-59a6-4ccd-9eae-d15c94fa5c53
  # Redirect to : {{Domain}}/share/janjipolitik/9fb657c1-59a6-4ccd-9eae-d15c94fa5c53
  # janjipolitik
  # Title : Pantau Bersama - Janji Politik - {{JudulJanPol}}
  # Description : {{JudulJanPol}} - {{DeskripsiJanpol}}
  # Thumbnail : https://pantaubersama.com/wp-content/uploads/2019/01/fav.png
  def janjipolitik
    url =  "/linimasa/v1/janji_politiks/" + params[:id]
    record = HTTParty.get(ENV["PEMILU_API_URL"] + url)
      .parsed_response["data"]["janji_politik"]

    @title = ["Pantau Bersama - Janji Politik -", record["title"]].join(" ")
    @description = [record["title"], record["body"]].join(" - ")
    @image = record["image"]["url"] || default_image
    @redirect_to = web_url("/share/janjipolitik/" + params[:id])

    set_meta_tags_for_record
  end

  # Example : /share/tanya/2c0896fe-826c-46d2-8a01-6a1974469d85
  # Redirect to : {{Domain}}/share/tanya/2c0896fe-826c-46d2-8a01-6a1974469d85
  # tanya
  # Title : Pantau Bersama - Tanya Kandidat oleh {{NamaLengkap}}
  # Description : {{NamaLengkap}} bertanya : {{Pertanyaan}}. Lihat yuk!
  # Thumbnail : https://pantaubersama.com/wp-content/uploads/2019/01/fav.png
  def tanya
    url = "/pendidikan_politik/v1/questions/" + params[:id]
    record = HTTParty.get(ENV["PEMILU_API_URL"] + url)
      .parsed_response["data"]["question"]

    @title = ["Pantau Bersama - Tanya Kandidat oleh", record["user"]["full_name"]].join(" ")
    @description = [record["user"]["full_name"], "bertanya :", record["body"] + ".", "Lihat yuk!"].join(" ")
    @image = default_image
    @redirect_to = web_url("/share/tanya/" + params[:id])

    set_meta_tags_for_record
  end

  # Example : /share/kuis/fdcc3f8a-9f04-4a9c-b57c-6cdec01e710f
  # Redirect to : {{Domain}}/share/kuis/fdcc3f8a-9f04-4a9c-b57c-6cdec01e710f
  # kuis
  # Title : Pantau Bersama - Kuis - {{JudulKuis}}
  # Description : {JudulKuis} - {{DeskripsiKuis}}
  # Thumbnail : {{GambarKuis}}
  def kuis
    url = "/pendidikan_politik/v1/quizzes/" + params[:id]
    record = HTTParty.get(ENV["PEMILU_API_URL"] + url)
      .parsed_response["data"]["quiz"]

    @title = ["Pantau Bersama - Kuis -", record["title"]].join(" ")
    @description = [record["title"], record["description"]].join(" - ")
    @image = record["image"]["url"] || default_image
    @redirect_to = web_url("/share/kuis/" + params[:id])

    set_meta_tags_for_record
  end

  # Example : /share/hasilkuis/9350ee89-5f6e-4085-ae96-49fe0236f5fb
  # Redirect to : {{Domain}}/share/hasilkuis/9350ee89-5f6e-4085-ae96-49fe0236f5fb
  # hasilkuis
  # Title : Pantau Bersama - Hasil Kuis {{JudulKuis}} dari {{NamaLengkap}}
  # Description : {{NamaLengkap}} telah mengikuti kuis {{JudulKuis}}. Lihat hasil Kuisnya yuk!
  # Thumbnail : {{GambarKuis}}
  def hasilkuis
    url = "/pendidikan_politik/v1/quiz_participations/" + params[:id] + "/result"
    record = HTTParty.get(ENV["PEMILU_API_URL"] + url)
      .parsed_response["data"]
    
    @title = ["Pantau Bersama - Hasil Kuis", record["quiz"]["title"], "dari", record["user"]["full_name"]].join(" ")
    @description = [record["user"]["full_name"], "telah mengikuti kuis", record["quiz"]["title"] + ".", "Lihat hasil Kuisnya yuk!"].join(" ")
    @image = record["quiz_participation"]["image_result"]["url"] || default_image
    @redirect_to = web_url("/share/hasilkuis/" + params[:id])

    set_meta_tags_for_record
  end

  # Example : /share/kecenderungan/c9242c5a-805b-4ef5-b3a7-2a7f25785cc8
  # Redirect to : {{Domain}}/share/kecenderungan/9350ee89-5f6e-4085-ae96-49fe0236f5fb
  # kecenderungan
  # Title : Pantau Bersama - Kecenderungan dari {{NamaLengkap}}
  # Description : {{NamaLengkap}} lebih suka jawaban dari {{NamaPaslon}}
  # Thumbnail : {{HasilKecenderungan}}
  def kecenderungan
    url = "/pendidikan_politik/v1/quiz_participations/quizzes?user_id=" + params[:id]
    record = HTTParty.get(ENV["PEMILU_API_URL"] + url)
      .parsed_response["data"]

    tim1_percentage = record["teams"].select{|x| x["team"]["id"] == 1}.last["percentage"]
    tim2_percentage = record["teams"].select{|x| x["team"]["id"] == 2}.last["percentage"]
    
    if tim1_percentage.to_i == tim2_percentage.to_i
      selected = [1, 2].sample
      @team_name = record["teams"].select{|x| x["team"]["id"] == selected}.last["team"]["title"]
      @team_percentage = selected == 1 ? tim1_percentage : tim2_percentage
    elsif tim1_percentage > tim2_percentage
      @team_name = record["teams"].select{|x| x["team"]["id"] == 1}.last["team"]["title"]
      @team_percentage = tim1_percentage
    else
      @team_name = record["teams"].select{|x| x["team"]["id"] == 2}.last["team"]["title"]
      @team_percentage = tim2_percentage
    end

    text = "#{record["user"]["full_name"]} lebih suka jawaban dari #{@team_name}"

    @title = ["Pantau Bersama - Kecenderungan", "dari", record["user"]["full_name"]].join(" ")
    @description = text
    @image = record["quiz_preference"]["image_result"]["url"] || default_image
    @redirect_to = web_url("/share/kecenderungan/" + params[:id])

    set_meta_tags_for_record
  end
  
  # Example : /share/badge/ff46f064-3f5a-421d-be6a-3e6b2314ae7e
  # Redirect to : {{Domain}}/profile/badge/9350ee89-5f6e-4085-ae96-49fe0236f5fb
  # badge
  # Title : Pantau Bersama - Badge {{NamaBadge}} didapatkan oleh {{NamaLengkap}}
  # Description : Yunan Helmy telah mendapatkan badge {{NamaBadge}}. Lihat yuk!
  # Thumbnail : {{HasilBadge}}
  def badge
    url = "/v1/achieved_badges/" + params[:id]
    record = HTTParty.get(ENV["AUTH_API_URL"] + url)
      .parsed_response["data"]["achieved_badge"]

    @title = ["Pantau Bersama - Badge", record["badge"]["name"],  "didapatkan oleh", record["user"]["full_name"]].join(" ")
    @description = [record["user"]["full_name"], "telah mendapatkan badge", record["badge"]["name"] + ".", "Lihat yuk!"].join(" ")
    @image = record["image_result"]["url"] || default_image
    @redirect_to = web_url("/share/badge/" + params[:id])

    set_meta_tags_for_record
  end

  def set_meta_tags_for_record
    set_meta_tags type: "website",
      title: @title,
      description: @description,
      og: {
        title: @title,
        description: @description,
        image: @image
      },
      twitter: {
        card: "summary",
        site: "@pantaubersama",
        title: @title,
        description: @description,
        image: {
          src: @image
        }
      }
  end

  private
    def web_url endpoint
      ENV["WEB_DOMAIN"] + endpoint
    end
end
