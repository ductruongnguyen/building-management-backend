package com.building.management.controller;

import com.building.management.entity.ComMemSalary;
import com.building.management.entity.CompanyMember;
import com.building.management.service.BMService;
import com.building.management.service.impl.ComMemImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController //Danh dau day la 1 API
@RequestMapping(path = "/company-member", produces = "application/json")
@CrossOrigin(origins = "*") //Cho phep ben ngoai goi den API bang IP mang
public class ComMemController {


    @Autowired //Goi CompanyMember
    private BMService<CompanyMember> comMemService;

    @Autowired
    private ComMemImpl comMemImpl;

    public ComMemController(BMService<CompanyMember> comMemService) {this.comMemService = comMemService; }

    @GetMapping("/all") //Method tra ve list model
    public Iterable<CompanyMember> getListCompanyMember(){
        return comMemService.findAll();
    }

    @GetMapping("/{MA_NV}") //Method tra ve 1 model theo id
    public CompanyMember companyMemberById(@PathVariable("MA_NV") String MA_NV) {
        Optional<CompanyMember> opCompanyMember = comMemService.findById(MA_NV);
        if (opCompanyMember.isPresent()) {
            return opCompanyMember.get();
        }
        return null;
    }
    @GetMapping("/search") //url "/search?keyword={name}: name phai viet dung ky tu hoa thuong theo ten cua model de lay ra thong tin cua model chua keyword nay
    public List<CompanyMember> companyMemberByKeyword(@RequestParam(name ="keyword", required = false, defaultValue = "") String name) {
        return comMemService.searchByKeyWord(name);
    }

    @PostMapping(consumes = "application/json") //Create mot model moi vao database
    @ResponseStatus(HttpStatus.CREATED)
    public CompanyMember postCompanyMember(@RequestBody CompanyMember companyMember) {
        return comMemService.save(companyMember);
    }

    @PutMapping("/{MA_NV}")
    @ResponseStatus(HttpStatus.CREATED) //Update mot model vao database
    public CompanyMember putCompanyMember(@RequestBody CompanyMember companyMember) {
        return comMemService.save(companyMember);
    }

    @DeleteMapping("/{MA_NV}") //Xoa mot model theo ID
    public void deleteCompanyMember(@PathVariable("MA_NV") String MA_NV) {
        try {
            comMemService.deleteById(MA_NV);
        } catch (EmptyResultDataAccessException e) {
        }
    }

    // Lay thong tin luong cua mot nhan vien theo ngay bat dau va ngay ket thuc  cu the
    @GetMapping("/salary/{ngay_BD}/{ngay_KT}/{maNV}")
    public List<ComMemSalary> getCompanyMemberByDate(@PathVariable("ngay_BD" ) String ngayBD, @PathVariable("ngay_KT") String ngayKT, @PathVariable("maNV") String maNV){
        return comMemImpl.getCompanyMemberByDate(ngayBD,ngayKT,maNV);
    }

    @GetMapping("/list-by-company")
    public List<CompanyMember> searchListComMemByIDCompany(@RequestParam(name ="MA_CT", required = false, defaultValue = "")String MA_CT) {
        return comMemImpl.searchListComMemByIDCompany(MA_CT);
    }

}
