
// [TB_PUSH_MESSAGE 구조 ]
// id : Int
// title
// message
//
//
//

import Foundation

public struct PushData : Hashable { //: Codable {
    public var id: Int
    public var title: String
    public var message : String
    public var insertDt:String
    public var isRead : Int
    public var readDt:String
    public var url:String
    
    public var isExpanded:Bool  = true
    
    public init(id: Int, title: String, message: String, insertDt: String, isRead: Int, readDt: String, url:String) {
        self.id = id
        self.title = title
        self.message = message
        self.insertDt = insertDt
        self.isRead = isRead
        self.readDt = readDt
        self.url = url
    }
    
}

public class TGSUDBPushEntity {
    
    public static let shared = TGSUDBPushEntity()
    
    
    private let COLUME : [String] = ["PUSH_ID", "TITLE", "MESSAGE", "INSERT_DT", "IS_READ", "READ_DT", "URL"]
    
    private init() {
        
    }
    
    public func createTable() {
        let query = """
                   CREATE TABLE IF NOT EXISTS \(TGSMConst.DB.DB_TABLENAME_PUSH) (
                   \(COLUME[0]) INTEGER PRIMARY KEY AUTOINCREMENT,
                   \(COLUME[1]) TEXT NOT NULL,
                   \(COLUME[2]) TEXT NOT NULL,
                   \(COLUME[3]) TEXT NOT NULL,
                   \(COLUME[4]) INT NOT NULL,
                   \(COLUME[5]) TEXT NOT NULL,
                   \(COLUME[6]) TEXT NOT NULL
                   );
                   """
        TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).createTable(query)
    }
    
    public func deleteTable() {
        TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).deleteTable(tableName: TGSMConst.DB.DB_TABLENAME_PUSH)
    }
    
    public func insertData(data : PushData) {
        //let insertQuery = "insert into myTable (id, my_name, my_age) values (?, ?, ?);"
        let insertQuery = "insert into \(TGSMConst.DB.DB_TABLENAME_PUSH) (\(COLUME.joined(separator: ", "))) values (?, ?, ?, ?, ?, ?, ?);"
        let values:[Int : Any] = [2:data.title, 3:data.message, 4:data.insertDt, 5:data.isRead, 6:data.readDt, 7:data.url]
        
        TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).insertData(query: insertQuery, values: values)
    }
    
    public func updateData(data : PushData) {
        // string 부분은 작은 따옴표 두 개로 감싸줘야 한다.
        //let queryString = "UPDATE myTable SET my_name = '\(name)', my_age = \(age) WHERE id == \(id)"
        let query = " UPDATE \(TGSMConst.DB.DB_TABLENAME_PUSH) SET "
        + " \(COLUME[1]) = '\(data.title)', "
        + " \(COLUME[2]) = '\(data.message)', "
        + " \(COLUME[3]) = '\(data.insertDt)', "
        + " \(COLUME[4]) = \(data.isRead), "
        + " \(COLUME[5]) = '\(data.readDt)' "
        + " \(COLUME[6]) = '\(data.url)' "
        + " WHERE \(COLUME[0]) == \(data.id) "
        TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).updateData(query: query)
    }
    public func updateReaded(id:Int?) {
        
        let nowDate = Date() // 현재의 Date (ex: 2020-08-13 09:14:48 +0000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 2020-08-13 16:30
        let str = dateFormatter.string(from: nowDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
        
        let query = " UPDATE \(TGSMConst.DB.DB_TABLENAME_PUSH) SET "
        + " \(COLUME[4]) = 1, "
        + " \(COLUME[5]) = '\(str)' "
        
        + (id == nil ? "" : " WHERE \(COLUME[0]) == \(id) ")
        TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).updateData(query: query)
    }
    
    
    public func readAllData() -> [PushData] {
        //let query: String = "select * from myTable;"
        let query: String = "select * from \(TGSMConst.DB.DB_TABLENAME_PUSH);"
        let types:[Any] = [Int.Type.self, String.Type.self, String.Type.self, String.Type.self, Int.Type.self, String.Type.self, String.Type.self]
        let arrResult = TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).readData(query: query, returnTypes: types)
        
        var arrPushData:[PushData] = []
        for result in arrResult {
            if result.count < 7 {
                continue
            }
//            let i = Int(result[0] as! Int32)
//            let a = result[1] as! String
            
            let pushData = PushData(
                id: Int(result[0] as! Int32),
                title: result[1] as! String,
                message: result[2] as! String,
                insertDt: result[3] as! String,
                isRead:Int(result[4] as! Int32),
                readDt: result[5] as! String,
                url: result[6] as! String)
            arrPushData.append(pushData)
        }
        return arrPushData
    }
    
    public func notReadDataCount() -> Int {
        //let query: String = "select * from myTable;"
        let query: String = "select count(*) from \(TGSMConst.DB.DB_TABLENAME_PUSH) where \(COLUME[4]) = 0;"
        let count  = TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).readCount(query: query)
        return count
    }

    
    public func deleteData(id:Int) -> Bool{
        //let queryString = "DELETE FROM myTable WHERE id == \(id)"
        let query = "DELETE FROM \(TGSMConst.DB.DB_TABLENAME_PUSH) WHERE \(COLUME[0]) == \(id);"
        return TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).deleteData(query: query)
    }
    public func deleteAllData() {
        let query = "DELETE FROM \(TGSMConst.DB.DB_TABLENAME_PUSH);"
        TGSUDBHelper.shared(TGSMConst.DB.DATABASENAME).deleteData(query: query)
    }
    
}

/*
//TGSUDBPushEntity.shared.deleteTable()
TGSUDBPushEntity.shared.createTable()
TGSUDBPushEntity.shared.deleteAllData()
var result = TGSUDBPushEntity.shared.readAllData()
print(result)

var a = PushData(id: 0, title: "title1", message: "1message가들어갑니다.", insertDt: "2023-10-05 11:22:00", isRead: 0, readDt: "")
var b = PushData(id: 0, title: "title2", message: "2message가들어갑니다.", insertDt: "2023-10-05 11:22:00", isRead: 0, readDt: "")
var c = PushData(id: 0, title: "title3", message: "3message가들어갑니다.", insertDt: "2023-10-05 11:22:00", isRead: 0, readDt: "")
TGSUDBPushEntity.shared.insertData(data: a)
TGSUDBPushEntity.shared.insertData(data: b)
TGSUDBPushEntity.shared.insertData(data: c)

result = TGSUDBPushEntity.shared.readAllData()
print(result)

var uData:PushData = result[0]
uData.title = "타이틀1"
uData.message = "메시지1"
uData.insertDt = "2023-10-05 11:22:33"
uData.isRead = 1
uData.readDt = "2023-10-05 18:00:00"

TGSUDBPushEntity.shared.updateData(data: uData)
result = TGSUDBPushEntity.shared.readAllData()
 print(result)

TGSUDBPushEntity.shared.updateReaded(id: result[1].id)

result = TGSUDBPushEntity.shared.readAllData()
 print(result)
*/
