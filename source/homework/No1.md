title: 数据库第一次作业
---

# My Database course homework
_The first homework Authored by Pengfei Yang_

### Preview Terms(Page.35)
_Order by Rows_

<table><thead><tr><th></th><th>English Phras</th><th></th><th>中文翻译</th><th></th></tr></thead><tbody><tr><td></td><td><code>Database system (DBS)</code></td><td></td><td>数据库系统</td><td></td></tr><tr><td></td><td><code>Data-definition language</code></td><td></td><td>数据定义语言</td><td></td></tr><tr><td></td><td><code>Database-system applications</code></td><td></td><td>数据库系统应用</td><td></td></tr><tr><td></td><td><code>Data-manipulation language</code></td><td></td><td>数据库操纵语言</td><td></td></tr><tr><td></td><td><code>File-processing systems</code></td><td></td><td>文件处理系统</td><td></td></tr><tr><td></td><td><code>Query language</code></td><td></td><td>查询语言</td><td></td></tr><tr><td></td><td><code>Data inconsistency</code></td><td></td><td>数据不一致性</td><td></td></tr><tr><td></td><td><code>Consistency constrains</code></td><td></td><td>一致性约束</td><td></td></tr><tr><td></td><td><code>Metadata</code></td><td></td><td>元数据</td><td></td></tr><tr><td></td><td><code>Data abstraction</code></td><td></td><td>数据抽象</td><td></td></tr><tr><td></td><td><code>Applcation program</code></td><td></td><td>应用程序</td><td></td></tr><tr><td></td><td><code>Instance</code></td><td></td><td>实例</td><td></td></tr><tr><td></td><td><code>Normalization</code></td><td></td><td>正常化</td><td></td></tr><tr><td></td><td><code>Schema</code></td><td></td><td>模式</td><td></td></tr><tr><td></td><td><code>Physical schema</code></td><td></td><td>物理模式</td><td></td></tr><tr><td></td><td><code>Logical schema</code></td><td></td><td>逻辑模式</td><td></td></tr><tr><td></td><td><code>Data dictionary</code></td><td></td><td>数据字典</td><td></td></tr><tr><td></td><td><code>Storage manager</code></td><td></td><td>储存管理</td><td></td></tr><tr><td></td><td><code>Query processor</code></td><td></td><td>查询处理器</td><td></td></tr><tr><td></td><td><code>Transactions</code></td><td></td><td>事务</td><td></td></tr><tr><td></td><td><code>Physical data independence</code></td><td></td><td>数据实际结构独立性</td><td></td></tr><tr><td></td><td><code>Atomicity</code></td><td></td><td>原子性</td><td></td></tr><tr><td></td><td><code>Data models</code></td><td></td><td>数据模型</td><td></td></tr><tr><td></td><td><code>Entity-relationship model</code></td><td></td><td>实体关系模型</td><td></td></tr><tr><td></td><td><code>Relational data model</code></td><td></td><td>关系数据模型</td><td></td></tr><tr><td></td><td><code>Object-based data model</code></td><td></td><td>对象数据模型</td><td></td></tr><tr><td></td><td><code>Semistructured data model</code></td><td></td><td>半结构化数据模型</td><td></td></tr><tr><td></td><td><code>Failure recovery</code></td><td></td><td>故障恢复</td><td></td></tr><tr><td></td><td><code>Concurrency control</code></td><td></td><td>并发控制</td><td></td></tr><tr><td></td><td><code>Two and three-tier database architectures</code></td><td></td><td>两层和三层数据库结架构</td><td></td></tr><tr><td></td><td><code>Data mining</code></td><td></td><td>数据挖掘</td><td></td></tr><tr><td></td><td><code>Database language</code></td><td></td><td>数据库语言</td><td></td></tr><tr><td></td><td><code>Database administrator(DBA)</code></td><td></td><td>数据库管理员</td><td></td></tr></tbody></table>

### Practice Exercises(Page.35)
_1.2_ List five ways in which the `type declaration system` of a language such as `Java` or `C++` differs from the `data definition language` used in a database.

+ in C++ (strongly typed language):


```C++
# declare primitive type
int num = 100;
double salary = 200.0;
wchar_t str[] = "this is wchar_t";

# declare structure
struct Stu 
{
 int num;
 wchar_t str[] name;
 float gpa;
} xcold = {20, "xcold", 4.0};

# declare object
int *a = new int(1000);
Vector<String> v = new Vector<String>(); 
```

+ in Javascript(weakly typed language):

```JavaScript
# declare primitive type
var num = 1024;
var isEnd = false;
var str = "iloveyou";

# declare object (in Javascript, anything is regarded as an object)
// Maybe you should define a Class named "Person" previously.
var person = new Person("xcold", 12);	
var arr = ['string', 12, false, 24.0];
```

### Exercises(Page.36)
_1.9_ Explain the concept of `physical data independence`, and ites importance in database systems.

+ About concept:
  `Physical data independence` means that the structure of data in database are independent of data in hardisk. Users are able to manipulate databases without doing anything to deal with diskette storage, because Database Management System(DBMS) has done these jobs and supportted services for users to process data.

  数据实际结构独立性意味着数据库中数据的结构独立于磁盘储存的数据的结构。因为数据库管理系统已经做好了磁盘储存的功能，提供给用户处理数据的服务，因此用户可以不需要动手操作任何相关与磁盘储存的工作就可以操纵数据库。

+ About importance:
	Without `Physical data independence`, when users update the structure their data in databases stored on the hardisk, they must update the structure of those data and relloc the storage space. `Physical data independence` simplify users' manipulation in dealing with data indatabases. In addition, the threshold of users has reduced a lot, because they can finish their work without mastering diskette storage.

	如果没有数据实际结构独立性，用户每次更改储存在磁盘上的数据库的数据结构时，他们必须需要磁盘上的储存结构并且重新分配储存空间。数据实际结构独立性极大简化了用户对数据库数据的操作。用户们可以不需要掌握磁盘储存的只是就能完成工作，因此用户使用数据库的门槛大大的降低。

Links source: 

1. [数据独立性-百度百科](http://baike.baidu.com/link?url=govHhPliRfAhRAvrYcBRWNeKjiR81Zx4Bk1SQ94q0izq-adqYwy6b7kFGJUqIaIOES92nWWrJNBvbeJhXbuuC_#1_2)
2. [Data independence-wikipedia](https://en.wikipedia.org/wiki/Data_independence)
