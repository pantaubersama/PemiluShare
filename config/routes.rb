Rails.application.routes.draw do
  resource :share, only: [:index] do
    collection do
      get "pilpres/:id", to: "share#pilpres", as: :pilpres
      get "janjipolitik/:id", to: "share#janjipolitik", as: :janjipolitik
      get "tanya/:id", to: "share#tanya", as: :tanya
      get "kuis/:id", to: "share#kuis", as: :kuis
      get "hasilkuis/:id", to: "share#hasilkuis", as: :hasilkuis
      get "kecenderungan/:id", to: "share#kecenderungan", as: :kecenderungan
      get "badge/:id", to: "share#badge", as: :badge
    end
  end
end
