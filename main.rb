require 'dotenv/load'
require 'faraday'
require 'faraday_middleware'

API_KEY = ENV['API_KEY']

connection = Faraday.new(
  url: "https://api.hubapi.com/",
  headers: {'Content-Type': 'application/json; charset=UTF-8'}
) do |conn|
  conn.request :url_encoded
  conn.request :json
  conn.request :retry, {
    max: 5,
    interval: 1,
    interval_randomness: 0.5,
    backoff_factor: 2
  }
  conn.response :json, content_type: /\bjson$/, parser_options: {symbolize_names: true}

  conn.adapter :net_http
end

email = "tatsuya.shimizu+test@hubspottest.co.jp"

### Contact
## 新規作成
# res = connection.post("contacts/v1/contact/?hapikey=#{API_KEY}", {
#   properties: [
#     {
#       property: :email,
#       value: email
#     },
#     {
#       property: :lastname,
#       value: "山田"
#     },
#     {
#       property: :firstname,
#       value: "テスト太郎"
#     },
#   ]
# })

# pp res.status
# pp res.body
# {:vid=>123456789,
#  :"canonical-vid"=>123456789,
#  :"merged-vids"=>[],
#  :"portal-id"=>123456789,
#  :"is-contact"=>true,
#  :"profile-url"=>"https://app.hubspot.com/contacts/123456789/contact/123456789",
#  :properties=>
#   {:firstname=>
#     {:value=>"テスト太郎",
#      :versions=>
#       [{:value=>"テスト太郎",
#         :"source-type"=>"API",
#         :"source-id"=>nil,
#         :"source-label"=>nil,
#         :timestamp=>1607923741136,
#         :selected=>false}]},
#    :email=>
#     {:value=>"tatsuya.shimizu+test@hubspottest.co.jp",
#      :versions=>
#       [{:value=>"tatsuya.shimizu+test@hubspottest.co.jp",
#         :"source-type"=>"API",
#         :"source-id"=>nil,
#         :"source-label"=>nil,
#         :timestamp=>1607923741136,
#         :selected=>false}]},
#    :lastname=>
#     {:value=>"山田",
#      :versions=>
#       [{:value=>"山田",
#         :"source-type"=>"API",
#         :"source-id"=>nil,
#         :"source-label"=>nil,
#         :timestamp=>1607923741136,
#         :selected=>false}]}},
#  :"form-submissions"=>[],
#  :"list-memberships"=>[],
#  :"identity-profiles"=>
#   [{:vid=>860451,
#     :"is-deleted"=>false,
#     :"is-contact"=>false,
#     :"pointer-vid"=>0,
#     :"previous-vid"=>0,
#     :"linked-vids"=>[],
#     :"saved-at-timestamp"=>0,
#     :"deleted-changed-timestamp"=>0,
#     :identities=>
#      [{:type=>"EMAIL",
#        :value=>"tatsuya.shimizu+test@hubspottest.co.jp",
#        :timestamp=>1607923741144,
#        :"is-primary"=>true,
#        :source=>"UNSPECIFIED"},
#  :"merge-audits"=>[]}

## 新規作成or更新
# res = connection.post("contacts/v1/contact/createOrUpdate/email/#{email}/?hapikey=#{API_KEY}", {
#   properties: [
#     {
#       property: :email,
#       value: email
#     },
#     {
#       property: :lastname,
#       value: "山田"
#     },
#     {
#       property: :firstname,
#       value: "テスト太郎2"
#     },
#   ]
# })
# pp res.status
# pp res.body
# {:vid=>123456789, :isNew=>false}

## 取得
# vid = res.body[:vid]
# res = connection.get("contacts/v1/contact/vid/#{vid}/profile/?hapikey=#{API_KEY}")
# pp res.status
# pp res.body

# res = connection.get("contacts/v1/contact/email/#{email}/profile/?hapikey=#{API_KEY}")
# pp res.status
# pp res.body

## 更新
# res = connection.post("contacts/v1/contact/vid/#{vid}/profile/?hapikey=#{API_KEY}", {
#   properties: [
#     {
#       property: :firstname,
#       value: "テスト太郎3",
#     },
#     {
#       property: :manage_client, # プロパティの内部名
#       value: "なし"
#     }
#   ]
# })
# pp res.status
# pp res.body # ""(レスポンスなし)

## 削除
# email指定のAPIはなし
# res = connection.delete("contacts/v1/contact/vid/#{vid}/?hapikey=#{API_KEY}")
# pp res.status
# pp res.body
# {:vid=>860351, :deleted=>true, :reason=>"OK"}

## 検索
# res = connection.get("contacts/v1/search/query/?hapikey=#{API_KEY}", {
#   q: :test # by email address, first and last name, phone number, or company.
# })
# pp res.status
# pp res.body

## 独自プロパティでの検索不可


### 会社
## 新規作成
# domain = "hubspottest.co.jp"
# res = connection.post("companies/v2/companies?hapikey=#{API_KEY}", {
#   properties: [
#     {
#       name: :domain,
#       value: domain
#     },
#     {
#       name: :name,
#       value: "Hubspot Test JP"
#     },
#     {
#       name: :description,
#       value: "Created by API"
#     }
#   ]
# })
# pp res.status
# pp res.body

# company_id = res.body[:company_id]

## 取得
# res = connection.get("companies/v2/companies/#{company_id}/?hapikey=#{API_KEY}")
# pp res.status
# pp res.body

## 更新
# res = connection.put("companies/v2/companies/#{company_id}?hapikey=#{API_KEY}", {
#   properties: [
#     {
#       name: :description,
#       value: "Updated by API"
#     }
#   ]
# })
# pp res.status
# pp res.body

## 削除
# res = connection.delete("companies/v2/companies/#{company_id}/?hapikey=#{API_KEY}")
# pp res.status
# pp res.body

### コンタクトを会社に追加
# vid = 123456789
# company_id = 123456789
# # 非推奨
# # res = connection.put("companies/v2/companies/#{company_id}/contacts/#{vid}/?hapikey=#{API_KEY}")
# res = connection.put("crm-associations/v1/associations/?hapikey=#{API_KEY}", {
#   fromObjectId: vid,
#   toObjectId: company_id,
#   category: "HUBSPOT_DEFINED",
#   definitionId: 1 # https://legacydocs.hubspot.com/docs/methods/crm-associations/crm-associations-overview
# })
# pp res.status
# pp res.body

### コンタクトを会社から削除
# res = connection.put("crm-associations/v1/associations/delete/?hapikey=#{API_KEY}", {
#   fromObjectId: vid,
#   toObjectId: company_id,
#   category: "HUBSPOT_DEFINED",
#   definitionId: 1 # https://legacydocs.hubspot.com/docs/methods/crm-associations/crm-associations-overview
# })
# pp res.status
# pp res.body