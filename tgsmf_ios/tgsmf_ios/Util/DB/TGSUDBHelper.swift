
import Foundation
import SQLite3

struct MyModel: Codable {
    var id: Int
    var myName: String
    var myAge: Int?
    
    
}

class TGSUDBHelper {
    private let TAG : String = "[TGSUDBHelper]"
    
    // 싱글톤 객체로 생성
    private static var inst:TGSUDBHelper!
    static func shared(_ dbName:String) -> TGSUDBHelper {
        if(inst == nil) {
            inst = TGSUDBHelper(dbName: dbName)
        }
        return inst
    }
    
    
    var databaseName:String  // db 이름은 항상 "DB이름.sqlite" 형식으로 해줄 것.
    var db : OpaquePointer? //db를 가리키는 포인터

    
    init(dbName:String) {
        self.databaseName = dbName
        
        self.db = createDB()
    }

    deinit {
        sqlite3_close(db)
    }
    
    private func createDB() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        do {
            let dbPath: String = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.databaseName).path
            
            if sqlite3_open(dbPath, &db) == SQLITE_OK {
                TGSULog.log(TAG, "Successfully created DB. Path: \(dbPath)")
                return db
            }
        } catch {
            TGSULog.log(TAG, "Error while creating Database -\(error.localizedDescription)")
        }
        return nil
    }
    
    func createTable(_ query:String){
        // 아래 query의 뜻.
        // mytable이라는 table을 생성한다. 필드는
        // id(int, auto-increment primary key)
        // my_name(String not null)
        // my_age(Int)
        // 로 구성한다.
        // auto-increment 속성은 INTEGER에만 가능하다.
//        let query = """
//           CREATE TABLE IF NOT EXISTS myTable(
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           my_name TEXT NOT NULL,
//           my_age INT
//           );
//           """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                TGSULog.log(TAG,"Creating table has been succesfully done. db: \(String(describing: self.db))")
                
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                TGSULog.log(TAG,"\nsqlte3_step failure while creating table: \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            TGSULog.log(TAG,"\nsqlite3_prepare failure while creating table: \(errorMessage)")
        }
        
        sqlite3_finalize(statement) // 메모리에서 sqlite3 할당 해제.
    }
    
    
     //values에서 key값은 테이블의 컬럼 인덱스를 나타낸다. 1부터 시작
    //insert는 read와 다르게 컬럼의 순서의 시작을 1 부터 한다.
    //(query, [0:1, 1:"name"])
    //func insertData(name: String, age: Int) {
    func insertData(query:String, values:[Int:Any]) {
        // id 는 Auto increment 속성을 갖고 있기에 빼줌.
        //let insertQuery = "insert into myTable (id, my_name, my_age) values (?, ?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            
            for (key, value) in values {
                if value is Int {
                    sqlite3_bind_int(statement, Int32(key), Int32(value as! Int))
                } else if value is String {
                    var new:String = value as! String
                    sqlite3_bind_text(statement, Int32(key), NSString(string:new).utf8String, -1, nil)
                }
            }
//            sqlite3_bind_text(statement, 2, name, -1, nil)
//            sqlite3_bind_int(statement, 3, Int32(age))
            
        }
        else {
            print("sqlite binding failure")
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("sqlite insertion success")
        }
        else {
            print("sqlite step failure")
        }
    }
    
    //func readData() -> [MyModel] {
    func readData(query:String, returnTypes:[Any]) -> [[Any]] {
        //let query: String = "select * from myTable;"
        var statement: OpaquePointer? = nil
        // 아래는 [MyModel]? 이 되면 값이 안 들어간다.
        // Nil을 인식하지 못하는 것으로..
        var arrResult: [[Any]] = []

        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return arrResult
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            
            var result:[Any] = []
            for (index, t) in returnTypes.enumerated() {
                if (t as! any Any.Type == Int.Type.self) {
                    result.append(sqlite3_column_int(statement, Int32(index)))
                } else if (t as! any Any.Type == String.Type.self) {
                    result.append(String(cString: sqlite3_column_text(statement, Int32(index))))
                }
            }
            arrResult.append(result)
            
//            let id = sqlite3_column_int(statement, 0) // 결과의 0번째 테이블 값
//            let title = String(cString: sqlite3_column_text(statement, 1)) // 결과의 1번째 테이블 값.
//            let messag = String(cString: sqlite3_column_text(statement, 2)) // 결과의 1번째 테이블 값.
//            let insertdt = String(cString: sqlite3_column_text(statement, 3)) // 결과의 1번째 테이블 값.
//            let read = sqlite3_column_int(statement, 4) // 결과의 0번째 테이블 값
//            let readdt = String(cString: sqlite3_column_text(statement, 5)) // 결과의 1번째 테이블 값.
            
//            let id = sqlite3_column_int(statement, 0) // 결과의 0번째 테이블 값
//            let name = String(cString: sqlite3_column_text(statement, 1)) // 결과의 1번째 테이블 값.
//            let age = sqlite3_column_int(statement, 2) // 결과의 2번째 테이블 값.
//            arrResult.append(MyModel(id: Int(id), myName: String(name), myAge: Int(age)))
        }
        sqlite3_finalize(statement)
        
        return arrResult
    }
    
    func readCount(query:String) -> Int {
        //let query: String = "select * from myTable;"
        var statement: OpaquePointer? = nil
        // 아래는 [MyModel]? 이 되면 값이 안 들어간다.
        // Nil을 인식하지 못하는 것으로..

        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return 0
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let count = Int(sqlite3_column_int(statement, 0) as! Int32)
            return count
        }
        sqlite3_finalize(statement)
        
        return 0
    }
    
    //func updateData(id: Int, name: String, age: Int) {
    func updateData(query : String) {
        var statement: OpaquePointer?
        // 등호 기호는 =이 아니라 ==이다.
        // string 부분은 작은 따옴표 두 개로 감싸줘야 한다.
        //let queryString = "UPDATE myTable SET my_name = '\(name)', my_age = \(age) WHERE id == \(id)"
        
        // 쿼리 준비.
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        // 쿼리 실행.
        if sqlite3_step(statement) != SQLITE_DONE {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        
        print("Update has been successfully done")
    }
    
    func deleteData(query:String) -> Bool {
        //let queryString = "DELETE FROM myTable WHERE id == \(id)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK {
            onSQLErrorPrintErrorMessage(db)
            return false
        }
        
        // 쿼리 실행.
        if sqlite3_step(statement) != SQLITE_DONE {
            onSQLErrorPrintErrorMessage(db)
            return false
        }
        
        print("delete has been successfully done")
        return true
    }
    
    func deleteTable(tableName: String) {
        let queryString = "DROP TABLE \(tableName)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        
        // 쿼리 실행.
        if sqlite3_step(statement) != SQLITE_DONE {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        
        print("drop table has been successfully done")
        
    }
    
    private func onSQLErrorPrintErrorMessage(_ db: OpaquePointer?) {
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("Error preparing update: \(errorMessage)")
        return
    }
}
