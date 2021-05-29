
URL=$1
ID=$2

[ -z $URL ] && { echo "Error: URL not found"; exit 3; }
[ -z $ID ] && { echo "Error: ID not found"; exit 3; }

curl -X DELETE "http://$1/api/v1/users/$2"
