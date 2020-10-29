class HomeController < ApplicationController
  before_action :check_user_agent_for_mobile
  
  def top
    # @shop = Shop.all.order(beer_price: "DESC")
    # @beer_price = Shop.minimum(:beer_price)
    @beers = ['ザ・プレミアム・モルツ', 'アサヒビール', 'よなよなエール', 'ビール', '生ビール']
  end

  def show
    # @shop = Shop.find_by(id: params[:id])
    @is_beers = [
      {
        'name'   => 'ザ・プレミアム・モルツ',
        'isBeer' => true,
      },
      {
        'name'   => 'アサヒビール',
        'isBeer' => true,
      },
      {
        'name'   => 'コロナビール',
        'isBeer' => false,
      },
      {
        'name'   => 'よなよなエール',
        'isBeer' => true,
      },
      {
        'name'   => 'ノンアルコールビール',
        'isBeer' => false,
      },
      {
        'name'   => 'ビール',
        'isBeer' => true,
      },
      {
        'name'   => '生ビール',
        'isBeer' => true,
      },
    ]
  end

  private

    def check_user_agent_for_mobile
      if request.from_smartphone?
        request.variant = :mobile
      end
    end
end
